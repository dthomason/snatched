import PIL
import os
import re
from PIL import Image

# This folder is gitignored so make sure to move anything out if you want to keep it
path = './conv'

isdir = os.path.isdir(path)

if not isdir:
	os.mkdir(path)
else:
	for everything in os.listdir(path):
		os.remove(os.path.join(dir, everything))

working_folder = input("folder with the .png files:")
converting = []
converted = []
converted_count = 0

print('Converting image files...')
try:

	dir_list = os.listdir(working_folder)

	for file in dir_list:

		if file.endswith('.png'):

			converting_file = working_folder + "/" + file
			if len(converting) == 0:
				converting = [converting_file]
			else:
				converting.append(converting_file)

			converted_file = path + "/" + file
			if len(converted) == 0:
				converted = [converted_file]
			else:
				converted.append(converted_file)

	print("found " + str(len(converting)) + "total image files")

	for idx, converting_img in converting:
		print("converting: " + converting_img)

		img = Image.open(converting_img)
		(width, height) = (img.width // 4, img.height // 4)
		img = img.resize((width, height), None, None, 2.0)
		img.save(converted[idx])

		converted_count += 1

	print("Successfully converted " + str(converted_count) + " image files")
except:
	print("Exception occurred!!")
