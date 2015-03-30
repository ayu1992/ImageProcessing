in Matlab console, execute :

1. For Rotation:
hisEqNew(imread(${source_image}), imread(${style_image}));

2. For Rotation+TMR:
Tu=hisEqNew(imread(${source_image},imread(${style_image});
out=TMRmain(imread(${source_image}, Tu);

3. For FCM + TMR
img=imread(${source_image});
map=imread(${style_image});
Tu=main(img, map);
out=TMRmain(img,Tu);
