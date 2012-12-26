require 'sketchup'
ext = SketchupExtension.new 'Erreurs404net_Sketchup', 'erreurs404net.rb'
ext.creator     = 'Nicolas Grillet (n.grillet@devictio.fr)'
ext.version     = '1.0.0'
ext.copyright   = '2012, Nicolas Grillet'
ext.description = ''

# Register and load the extension on startup.
Sketchup.register_extension ext, true

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
cmd.small_icon = File.dirname(__FILE__)+"\\Erreurs404net\\citys.png"
cmd.large_icon = File.dirname(__FILE__)+"\\Erreurs404net\\city.png"
cmd.status_bar_text = "Generate City"
cmd.tooltip = "Generate a city"
menu.add_item(cmd)
