Project date: December, 2013
code execution:
in Matlab console
1. Rotation:
>>hisEqNew(imread(${source_image}), imread(${style_image}));

2. Rotation+TMR:
>>Tu=hisEqNew(imread(${source_image},imread(${style_image});
>>out=TMRmain(imread(${source_image}, Tu);

3. FCM + TMR
>>img=imread(${source_image});
>>map=imread(${style_image});
>>Tu=main(img, map);
>>out=TMRmain(img,Tu);
