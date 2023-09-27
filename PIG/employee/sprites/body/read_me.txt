Every sprite reprezent one part of the final image. 

	Sprite is divide to frames. Horrizontal frames reprezents diffrents colors. Vertical repezents diffrent types of the part. Look of the type can be influence by state of reprezented image or other  sprites. In that case vertical frame is calculated via number_of_modyfication*type+modyfication formula.

	In engine every sprite has Node2D and Sprite2D nodes for every color as children of Node2D. Node2D is named after part that reprezent. Sprite2D nodes are named after color.

name of the file: 
	<part>_<number of vertical frames>_<number of color>.png
or
	<part>_<number of vertical frames>_<number of color>_<state or sprite that influence this sprite>.png

types of influences:
	ud - up down
	b - body
	d - detail
	s - smile