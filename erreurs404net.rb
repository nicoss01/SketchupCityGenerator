require 'sketchup'

menu = UI.menu("Draw").add_submenu("Erreurs404net")

cmd = UI::Command.new("City") { 
	model	= Sketchup.active_model
	ents		= model.active_entities
	materials = model.materials
	rues=[0.m,0.m,0.m,20.m,0.m,0.m,20.m,0.m]
	m1 = materials.add "Building1"
	m1.texture = File.dirname(__FILE__)+"\\Erreurs404net\\building1.jpg"
	m2 = materials.add "Building2"
	m2.texture = File.dirname(__FILE__)+"\\Erreurs404net\\building2.jpg"
	m3 = materials.add "Building3"
	m3.texture = File.dirname(__FILE__)+"\\Erreurs404net\\building3.jpg"
	m4 = materials.add "Building4"
	m4.texture = File.dirname(__FILE__)+"\\Erreurs404net\\building4.jpg"
	m5 = materials.add "Building5"
	m5.texture = File.dirname(__FILE__)+"\\Erreurs404net\\building5.jpg"
	m1.texture.size = [30.m,40.m]
	m2.texture.size = [30.m,40.m]
	m3.texture.size = [30.m,40.m]
	m4.texture.size = [30.m,40.m]
	m5.texture.size = [30.m,40.m]
	textures=["Building1","Building2","Building3","Building4","Building5"]
	comgrp 	= []

	wx 		= rand*50.m+50.m
	wz		= rand*50.m+50.m
	# Prompts and default values.
	prompts 	= ["Nombre de rues horizontales", "Nombre de rues verticales","Hauteur maximum des buildings"]

	values 	= [15,25,250.m]
	results 	= UI.inputbox prompts, values, "Parametres de la ville"
	nbz		= results[0]*120.m
	nbx		= results[1]*120.m
	hb		= results[2]-50.m
	z=0
	dlg = UI::WebDialog.new("City in progress...", true,"ShowSketchUpDotCom", 200, 200, 300, 250, true);
	dlg.write_image File.dirname(__FILE__)+"\\Erreurs404net\\loading.png", 0, 0, 190, 190
	dlg.show	
	while z<=nbz
		x=0.m
		while x<=nbx
			model.start_operation "Building in progress"
			ent 	= Sketchup.active_model.entities
			face 	= ent.add_face [x,(z-(wz/2)),0],[x+wx,(z-(wz/2)),0],[x+wx,(z-(wz/2))+wz,0] ,[x,(z-(wz/2))+wz,0]
			face.material = textures[Integer(rand*5)]
			face.reverse!
			h=rand*hb+50.m
			face.pushpull h
			face 	= ent.add_face [x,(z-(wz/2)),h],[x+wx,(z-(wz/2)),h],[x+wx,(z-(wz/2))+wz,h] ,[x,(z-(wz/2))+wz,h]
			face.material = 0x999999
			face.reverse!
			face.pushpull 2.m,true
			x	+= wx+rues[rand*8]
			wx 	= rand*50.m+50.m
			wz	= rand*50.m+50.m
			model.commit_operation
		end
		z+= rand*40.m+100.m
	end
	eye = [nbx,-nbz/2,2000.m]
	target = [nbx/2,nbz/2,0]
	up = [0,0,1]
	my_camera = Sketchup::Camera.new eye, target, up

	# Get a handle to the current view and change its camera.
	view = Sketchup.active_model.active_view
	view.camera = my_camera
	dlg.close
	UI.messagebox "Votre ville mesure #{nbx.to_km} Km x #{nbz.to_km} Km"
}
cmd.status_bar_text = "Generate City"
cmd.tooltip = "Generate a city"
menu.add_item(cmd)

cmd2 = UI::Command.new("House") { 
	model	= Sketchup.active_model
	ents		= model.active_entities
	materials = model.materials
	prompts 	= ["Longueur", "Largeur","Hauteur","Epaisseur des murs","Hauteur du toit"]
	values 	= [10.m,10.m,3.m,50.cm,2.m]
	results 	= UI.inputbox prompts, values, "Parametres de la maison"
	model.start_operation "House in progress"
	ent 	= Sketchup.active_model.entities
	house	= ent.add_face [0,0,0],[0,results[1],0],[results[0],results[1],0] ,[results[0],0,0]
	house.reverse!
	house.pushpull results[2]
	house2	= ent.add_face [results[3],results[3],0],[results[3],results[1]-results[3],0],[results[0]-results[3],results[1]-results[3],0] ,[results[0]-results[3],results[3],0]
	house2.reverse!
	house2.pushpull results[2]-results[3]
	point1 = Geom::Point3d.new (0,results[1]/2,results[2])
	point2 = Geom::Point3d.new (results[0],results[1]/2,results[2])
	toit = ents.add_line point1,point2
	transform = Geom::Transformation.new([0,0,results[4]])
	ents.transform_entities(transform, toit)
	house3	= ent.add_face [results[3],results[3],0],[results[3],results[1]-results[3],0],[results[0]-results[3],results[1]-results[3],0] ,[results[0]-results[3],results[3],0]
	model.commit_operation
}
cmd2.status_bar_text = "Generate House"
cmd2.tooltip = "Generate a House"
menu.add_item(cmd2)
cmd3 = UI::Command.new("Houses") { 
	model	= Sketchup.active_model
	ents		= model.active_entities
	materials = model.materials
	prompts 	= ["Longueur", "Largeur","Hauteur","Epaisseur des murs","Hauteur du toit"]
	values 	= [10.m,10.m,3.m,50.cm,2.m]
	results 	= UI.inputbox prompts, values, "Parametres de la maison"
	y=0.m
	while y<=300.m
		x=0.m
		while x<=300.m
			ratio=rand*1.6+0.9
			model.start_operation "House in progress"
			ent 	= Sketchup.active_model.entities
			house	= ent.add_face [x,y,0],[x,y+results[1],0],[x+results[0],y+results[1],0] ,[x+results[0],y,0]
			house.reverse!
			house.pushpull results[2]*ratio
			house2	= ent.add_face [x+results[3],y+results[3],0],[x+results[3],y+results[1]-results[3],0],[x+results[0]-results[3],y+results[1]-results[3],0] ,[x+results[0]-results[3],y+results[3],0]
			house2.reverse!
			house2.pushpull results[2]*ratio-results[3]
			point1 = Geom::Point3d.new (x,y+results[1]/2,results[2]*ratio)
			point2 = Geom::Point3d.new (x+results[0],y+results[1]/2,results[2]*ratio)
			toit = ents.add_line point1,point2
			transform = Geom::Transformation.new([0,0,results[4]])
			ents.transform_entities(transform, toit)
			house3	= ent.add_face [x+results[3],y+results[3],0],[x+results[3],y+results[1]-results[3],0],[x+results[0]-results[3],y+results[1]-results[3],0] ,[x+results[0]-results[3],y+results[3],0]
			model.commit_operation
			x	+= results[1]+rand*20.m
		end
		y+= results[0]+rand*20.m
	end
}
cmd3.status_bar_text = "Generate Houses"
cmd3.tooltip = "Generate Houses"
menu.add_item(cmd3)

