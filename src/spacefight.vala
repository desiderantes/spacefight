/* -*- Mode: vala; tab-width: 4; intend-tabs-mode: t -*- */
/* spacefight.c
 * spacefight.vala
 * Copyright (C) Mario Daniel Ruiz Saavedra 2013 - 2016 <desiderantes@rocketmail.com>
 * SpaceFight is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * SpaceFight is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

using GLib;
using SDL;
using SDLImage;
namespace SpaceFight{
	public class SpaceFight : Application {
		private Sprite  button1;
		private Sprite  button2;
		private Sprite  button3;
		private MusicManager music;
		private Video.Surface icon;
		protected static Video.Window window;
		private static Video.Renderer render;
		private const uint16 SCREEN_WIDTH = 800;
		private const uint16 SCREEN_HEIGHT = 600;
		private const uint16 SCREEN_BPP = 24;
		private const uint8 DELAY = 10;
		private uint16 ex=SCREEN_WIDTH / 40;


		public SpaceFight(){
			init_video ();
			init_music ();
		}

		public static int main (string[] args){
			SDL.init(InitFlag.EVERYTHING);
			SDLImage.init(SDLImage.InitFlags.ALL);
			SDLTTF.init();
			var app = new SpaceFight();
			app.run();
			SDLImage.quit();
			SDLTTF.quit();
			SDL.quit();
			return 0;
		}
		protected override void activate() {
			window.show ();
			menu();
		}
		private void menu(){
			uint16 ex=SCREEN_WIDTH / 40;
			uint16 ey =(SCREEN_HEIGHT/10) * 6 ;
			bool good = true;
			var splash = new Sprite(render,"splash", 0,0);
			var selection = new Sprite(render,"selector",0,0);
			Sprite buttons[5];
			if(splash.actual_frame== null){ 
				GLib.error("Unable to load resource: %s\n", SDL.Error.get_error());
			}

			splash.draw();
			for (int i = 0; i < 5; i++){
				buttons[i] = new Sprite(render,"img/button"+(i+1).to_string()+".bmp",0,0);
				buttons[i].place.x=SCREEN_WIDTH/2;
				buttons[i].place.y=ey;
				ey+= SCREEN_WIDTH/12;
				if(buttons[i].actual_frame == null){// En caso de no cargarse alguna imagen, con malévolos motivos de depuración
					GLib.error("Unable to load button resource %d: %s\n", i, SDL.get_error());
				}
				buttons[i].actual_frame.set_color_mod(255, 255, 255);
				buttons[i].draw();
			}
			selection.place.x= buttons[0].place.x;
			selection.place.y= buttons[0].place.y;
			selection.place.h= buttons[0].place.h;
			selection.place.w= buttons[0].place.w;
			selection.actual_frame.set_alpha_mod(150);
			selection.draw();
			const string posnam = "position";
			selection.set_data<uint16>(posnam, 0);
			for (SDL.Event event = {0}; event.type != SDL.EventType.QUIT; Event.poll (out event)){
				render.present();
				switch (event.type) {
					case EventType.KEYDOWN:
						switch ( event.key.keysym.sym ){
						case Input.Keycode.ESCAPE:
							// ESC key was pressed
							return;
							break;
						case Input.Keycode.UP:
							if(selection.get_data<uint16>(posnam) == 0){
								break;
							}else{
								selection.set_data<uint16>(posnam,selection.get_data<uint16>(posnam) -1);
								selection.place.y -=40;
								render.present();
							}
							break;
						case Input.Keycode.DOWN:
							if (selection.get_data<uint16>(posnam) ==4){
								break;
							}else{
								selection.set_data<uint16>(posnam,selection.get_data<uint16>(posnam) +1);
								selection.place.y +=40;
								render.present();
							}
							break;
						case Input.Keycode.RETURN:
							switch (selection.get_data<uint16>(posnam)){
								case 0:
									var game = new Game(1, render, SCREEN_WIDTH, SCREEN_HEIGHT);
									game.run();
									splash.draw();
									render.present();
									break;
								case 1:
									var game = new Game(2, render, SCREEN_WIDTH, SCREEN_HEIGHT);
									game.run();
									splash.draw();
									render.present();
									break;
								case 2:
									var game = new Game(3, render, SCREEN_WIDTH, SCREEN_HEIGHT);
									game.run();
									splash.draw();
									render.present();
									break;
								case 3:
									instructions();
									splash.draw();
									render.present();
									break;
								case 4:
									return;
									break;
								default:
									break;
							}
							break;
						default:
							break;
					}
					break;
				}                
			}



		}
		private void init_video() {	
			window = new Video.Window("Space Fight", Video.Window.POS_CENTERED, Video.Window.POS_CENTERED, SCREEN_WIDTH, SCREEN_HEIGHT, SDL.InitFlag.EVERYTHING);
			if (window == null) {
				GLib.error("Failed to start: Are you sure there is a SDL2 lib on your system?");
			}
			SDLImage.init(SDLImage.InitFlags.ALL);
			render = Video.Renderer.create(window, 0, SDL.RendererFlags.ACCELERATED); 
			icon = new Video.Surface.from_bmp ("img/icono.bmp");
			window.set_icon(icon);
			SDL.GL.set_attribute(SDL.GL.Attributes.DOUBLEBUFFER, 1);
		}

		public void init_music(){
			music = MusicManager.instance;
		}

		private void instructions(){
			var text = new Sprite(render,"instructions",0,0);
			if(text.actual_frame== null){ 
				GLib.error("Unable to load image: %s\n", SDL.get_error());
			}
			text.draw();
			render.present();
			for (SDL.Event e = {0}; e.type != SDL.EventType.QUIT; Event.poll (out e)){
				render.present ();

			}
		}
	}
}
