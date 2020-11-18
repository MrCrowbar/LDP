#!/usr/bin/env python
# coding: utf-8

# # Empezar desde aquí

# In[1]:


import os
import torch
import torchvision
import torch.nn as nn
import torch.nn.functional as F
from torchvision import transforms
import matplotlib.pyplot as plt
import numpy as np
import cv2
import pandas as pd
from PIL import Image, ImageDraw


# In[2]:


if (torch.cuda.is_available()):
    device = torch.device("cuda")
    print(device, torch.cuda.get_device_name(0))
else:
    device = torch.device("cpu")
    print(device)


# In[3]:


# Definimos nuestro dataset y dataloader

class TerniumDataset(torch.utils.data.Dataset):
    def __init__(self, root, transforms=None):
        # Guardamos nuestras variables base
        self.root = root
        self.transforms = transforms
        self.device = device
        self.images = list(sorted(os.listdir(os.path.join(root, "Images"))))
        self.anotations = list(sorted(os.listdir(os.path.join(root, "Anotations"))))

    def __getitem__(self, idx):
        # Obtenemos paths de imagen y anotaciones
        img_path = os.path.join(self.root, "Images", self.images[idx])
        txt_path = os.path.join(self.root, "Anotations", self.anotations[idx])
        imgPIL = Image.open(img_path).convert("RGB")
        img_size = imgPIL.size
        
        img = cv2.imread(img_path)
        img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)

        #txt_file = pd.read_csv(txt_path, sep=" ", header=None)
        txt_file = pd.read_csv(txt_path, header=None, delim_whitespace=True)
        txt_file = txt_file.to_numpy()

        # Convertimos anotaciones de formato YOLO a Pascal
        coords = txt_file[:, 1:]
        labels = txt_file[:, 0]

        size = (img.shape[1], img.shape[0])
        n_boxes = coords.shape[0]

        boxes = []
        for i in range(n_boxes):
            box = self.convertYoloToPascal(size, coords[i])
            boxes.append(box)

        boxes = torch.tensor(boxes,dtype = torch.int)
        labels = torch.tensor(labels, dtype = torch.int64)
        #print('BOXES: ',boxes.shape)
        
        #AGREGADOS PARA EVALUATION CON COCO
        image_id = torch.tensor([idx])
        area = (boxes[:, 3] - boxes[:, 1]) * (boxes[:, 2] - boxes[:, 0])
        iscrowd = torch.zeros((n_boxes), dtype = torch.int64)
        
        # Creamos nuestro diccionario que contiene la información
        target = {}
        target["boxes"] = boxes
        target["labels"] = labels
        
        #AGEGADOS
        target["image_id"] = image_id
        target["area"] = area
        target["iscrowd"] = iscrowd

        if self.transforms is not None:
            imgPIL, target = self.transforms(imgPIL, target)

        return imgPIL, target

    def __len__(self):
        return len(self.images)
    
    def convertYoloToPascal(self, size, coord):
        x2 = int( ( (2 * size[0] * float(coord[0])) + (size[0] * float(coord[2]))) / 2)
        x1 = int( ( (2 * size[0] * float(coord[0])) - (size[0] * float(coord[2]))) / 2)

        y2 = int( ( (2 * size[1] * float(coord[1])) + (size[1] * float(coord[3]))) / 2)
        y1 = int( ( (2 * size[1] * float(coord[1])) - (size[1] * float(coord[3]))) / 2)

        return (x1,y1,x2,y2)


# In[4]:


from engine import train_one_epoch, evaluate
import utils
import transforms as T

def get_transform(train):
    transforms = []
    # converts the image, a PIL image, into a PyTorch Tensor
    transforms.append(T.ToTensor())
    if train:
        # during training, randomly flip the training images
        # and ground-truth for data augmentation
        transforms.append(T.RandomHorizontalFlip(0.5))
    return T.Compose(transforms)


# In[5]:


def loadCheckpoint:
    #model = TheModelClass(*args, **kwargs)
    #optimizer = TheOptimizerClass(*args, **kwargs)

    checkpoint = torch.load(PATH)
    model.load_state_dict(checkpoint['model_state_dict'])
    optimizer.load_state_dict(checkpoint['optimizer_state_dict'])
    epoch = checkpoint['epoch']
    loss = checkpoint['loss']

    model.eval()
    # - or -
    model.train()


# In[6]:


def test(model, test_loader, device=torch.device('cuda')):
    cpu = torch.device('cpu')
    torch.cuda.empty_cache()
    predictions = []
    images = []
    model.eval()
    with torch.no_grad():
        for img_batch, targets in test_loader:
            image = list(img.to(device) for img in img_batch)
            outputs = model(image)
            #predictions.append(list(out.cpu().numpy() for out in outputs))
            #images.append(list(img.cpu().numpy() for img in img_batch))
            predictions.append(outputs)
            images.append(image)
    return predictions, images


# In[11]:


from engine import train_one_epoch, evaluate
from torchvision.models.detection.faster_rcnn import FastRCNNPredictor
import utils, os

def train(epochs, weight_path, checkpoint_path, data_path, paramsT, paramsV, device, model):
    training_path = os.path.join(data_path,'Training')
    validation_path = os.path.join(data_path,'Testing')
    
    torch.manual_seed(0)
    np.random.seed(0)
    root_path = data_path
    
    # Datasets y Generators
    training_set = TerniumDataset(training_path, get_transform(train=True))
    #validation_set = TerniumDataset(validation_path, get_transform(train=False))
    #validation_set = TerniumDataset(training_path, get_transform(train=False))
    
    # split the dataset in train and test set
    indices = torch.randperm(len(training_set)).tolist()
    training_set = torch.utils.data.Subset(training_set, indices[0:1])
    #validation_set = torch.utils.data.Subset(validation_set, indices[200:250])

    training_loader = torch.utils.data.DataLoader(training_set, **paramsT)
    #validation_loader = torch.utils.data.DataLoader(validation_set, **paramsV)
    
    #seguir = input('seguir')
    # Construct an optimizer
    params = [p for p in model.parameters() if p.requires_grad]
    optimizer = torch.optim.SGD(params, lr=0.005, momentum=0.9, weight_decay=0.0005)

    # and a learning rate scheduler
    lr_scheduler = torch.optim.lr_scheduler.StepLR(optimizer, step_size=3, gamma=0.1)
    model.to(device)
    
    for epoch in range(epochs):
        print("\n==============================\n")
        print("Epoch = " + str(epoch))
        
        # Training con utils
        train_one_epoch(model, optimizer, training_loader, device, epoch, print_freq=10)
        
        # update the learning rate
        lr_scheduler.step()
        state = model.state_dict()
        save_path = os.path.join(weight_path,'last_weight.pth')
        torch.save(state, save_path)
        print("SAVED MODEL in epoch",epoch)
    torch.cuda.empty_cache()


# # Main

# In[8]:


def loadModel(PATH, base_model, num_classes = 44):
    model = base_model
    in_features = model.roi_heads.box_predictor.cls_score.in_features
    model.roi_heads.box_predictor = FastRCNNPredictor(in_features, num_classes)
    model.load_state_dict(torch.load(PATH))
    return model


# In[9]:


def createModel():
    model = torchvision.models.detection.fasterrcnn_resnet50_fpn(pretrained=True)
    num_classes = 44
    in_features = model.roi_heads.box_predictor.cls_score.in_features
    model.roi_heads.box_predictor = FastRCNNPredictor(in_features, num_classes)
    return model


# In[10]:


epochs = 2
weight_path = '/home/crowbar/Weights/'
checkpoint_path = '.CHECKPOINT.pth'
data_path = '/home/crowbar/'

paramsT = {
    'batch_size':3,
    'shuffle': True,
    'num_workers': 6,
    'collate_fn':utils.collate_fn
    }

paramsV = {
    'batch_size':2,
    'shuffle': False,
    'num_workers': 6,
    'collate_fn':utils.collate_fn
    }

device = torch.device('cuda')

PATH = './FASTER_WEIGHT.pth'
model = torchvision.models.detection.fasterrcnn_resnet50_fpn(pretrained=True)
model = loadModel(PATH, model, num_classes = 44)

if __name__ == "__main__":
    torch.cuda.empty_cache()
    train(epochs, weight_path, checkpoint_path, data_path, paramsT, paramsV, device, model)
    torch.cuda.empty_cache()


# # Cargar peso guardado

# In[10]:


testPATH = '/home/crowbar/Testing/'
PATH = './FASTER_WEIGHT.pth'
device = torch.device('cuda')
model = torchvision.models.detection.fasterrcnn_resnet50_fpn(pretrained=True)
model = loadModel(PATH, model, num_classes = 44)
model.to(device)


# In[11]:


paramsV = {
    'batch_size':2,
    'shuffle': False,
    'num_workers': 6,
    'collate_fn':utils.collate_fn
    }
testing_set = TerniumDataset(testPATH, get_transform(train=False))
indices = torch.randperm(len(testing_set)).tolist()
testing_set = torch.utils.data.Subset(testing_set, indices[:10])
test_loader = torch.utils.data.DataLoader(testing_set, **paramsV)
predictions, images = test(model, test_loader, device)


# In[12]:


txt = open("../classes.txt","r")
txtfile = txt.read()
CLASSES = txtfile.split('\n')
CLASSES.pop()


# In[13]:


test_images = []
for img in images:
    for i in img:
        im = Image.fromarray(i.mul(255).permute(1, 2, 0).cpu().byte().numpy())
        test_images.append(im)
boxes = []
labels = []
scores = []
for batch in predictions:
    for b in batch:
        boxes.append(b['boxes'].cpu().numpy())
        labels.append(b['labels'].cpu().numpy())
        scores.append(b['scores'].cpu().numpy())
        del b
    del batch
    torch.cuda.empty_cache()


# In[ ]:


thresh = 0.1
categorias = { i : CLASSES[i] for i in range(0, len(CLASSES) ) }

for n_img, img in enumerate(test_images):
    image = cv2.cvtColor(np.array(img), cv2.COLOR_RGB2BGR)
    nombres = labels[n_img]
    for n_box, box in enumerate(boxes[n_img]):
        if scores[n_img][n_box] > thresh:
            x_min = box[0]
            y_min = box[1]
            x_max = box[2]
            y_max = box[3]
            categoria = categorias[nombres[n_box]]
            cv2.rectangle(image, (x_min,y_min), (x_max,y_max), color=(0,255,0), thickness=2)
            cv2.putText(image, str(categoria), (x_min, y_min), cv2.FONT_HERSHEY_SIMPLEX, 3, (255,0,0), thickness=3)
    ver = input('Ver imagen')
    if ver in ('Y','y','yes'):
        plt.figure(figsize = (20,20))
        plt.imshow(image)
        plt.show()


# In[42]:


from PIL import ImageDraw
image = cv2.cvtColor(np.array(im), cv2.COLOR_RGB2BGR)
boxes = prediction[0]['boxes'].cpu().numpy()
scores = prediction[0]['scores'].cpu().numpy()
labels = prediction[0]['labels'].cpu().numpy()

print("Scores: ", scores)
print("Boxes: ", boxes)
print("Labels: ",labels)
s = input('seguir')
boxTemp = []
for i, score in enumerate(scores):
    if score > 0.5:
        boxTemp.append(boxes[i])

#boxes = boxTemp
print(boxes)
for i in range(len(boxes)):
    x_min = boxes[i][0]
    y_min = boxes[i][1]
    x_max = boxes[i][2]
    y_max = boxes[i][3]
    cv2.rectangle(image, (x_min,y_min), (x_max,y_max), color=(0,255,0), thickness=2)
    cv2.putText(image, str(int(labels[i])), (x_min, y_min), cv2.FONT_HERSHEY_SIMPLEX, 3, (255,0,0), thickness=3)

plt.figure(figsize = (20,20))
plt.imshow(image)
plt.show()


# In[ ]:


# ---------------- DEBUGING IMPORTANTE -------------------------
    #training_set = TerniumDataset(root_path)
    #print("dataset1",training_set[0])
    #seguir = input('Seguir')
    
    
    #print("dataset2",training_set[0])
    #seguir = input('Seguir')
    
    
    #images,targets = next(iter(training_generator))
    #images = images.to(device)
    #print("images 1: ",images)
    #print("targets 1: ",targets)
    
    #seguir = input('Seguir')
    
    #targets = [{k: v for k, v in t.items()} for t in targets]
    #targets = [{key:value for (key,value) in targets.items()}]
    #images = list(image.to(device) for image in images)
    #print("images2",images)
    #print("targets 2",targets)
    
    #seguir = input('Seguir')
    # ----------------------------------------------------------------
    
 # -------------------------- Training a mano -------------------------------------------
        # El batch_idx es un arreglo de tamaño bach_size con las imagenes dentro del batch
        '''
        for batch_idx, batch in training_generator:
            images = list(image.to(device) for image in batch_idx)
            targets = []
            for b in batch:
                target = {}
                target['labels'] = b['labels'].to(device)
                target['boxes']  = b['boxes'].to(device)
                targets.append(target)
            output = model(images, targets)
            print(output)
            
            #del images
            #torch.cuda.empty_cache()
        '''
# -------------------------------------Validation a mano-----------------------------------------------------
'''
with torch.no_grad():
        for data in validation_generator:
            images, labels = data[0].to(device), data[1].to(device)
            outputs = model(images)
            _, predicted = torch.max(outputs.data, 1)
            total += labels.size(0)
            correct += (predicted == labels).sum().item()
'''


# In[17]:


device = 'cuda'
torch.cuda.empty_cache()
torch.cuda.memory_allocated(device)
torch.cuda.memory_summary(device)


# In[ ]:




