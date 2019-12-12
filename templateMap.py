import cv2
import numpy as np
import pyautogui


stash = pyautogui.screenshot(region=(0, 0, 870, 1060))
stash.save('stash.png')

img_rgb = cv2.imread('stash.png')
img_gray = cv2.cvtColor(img_rgb, cv2.COLOR_BGR2GRAY)
template = cv2.imread('./Templates/templateMap.png', 0)
w, h = template.shape[::-1]

res = cv2.matchTemplate(img_gray, template, cv2.TM_CCOEFF_NORMED)
threshold = 0.58
loc = np.where(res >= threshold)

lista = []
for pt in zip(*loc[::-1]):
    cv2.rectangle(img_rgb, pt, (pt[0] + w, pt[1] + h), (0,0,255), 2)
    #print(pt[0]+15, ",", pt[1]+15)
    lista.append("{},{} \n".format(pt[0]+15, pt[1]+15))


i = 1
while i < len(lista):
    x, y = int(lista[i - 1].split(",")[0]), int(lista[i - 1].split(",")[1])
    x2, y2 = int(lista[i].split(",")[0]), int(lista[i].split(",")[1])

    if abs(x2 - x) < 10 and abs(y2 - y) < 10:
        lista.pop(i - 1)
    else:
        i += 1

txt = open('koordinaatitMap.csv', "w+")
#cv2.imwrite('res.png', img_rgb)

for line in lista:
    txt.write(line)

txt.close()