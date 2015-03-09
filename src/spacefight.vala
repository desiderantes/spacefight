/* -*- Mode: vala; tab-width: 4; intend-tabs-mode: t -*- */
/* spacefight.c
 * spacefight.vala
 * Copyright (C) Mario Daniel Ruiz Saavedra 2013 - 2015 <desiderantes@rocketmail.com>
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
		private Sprite  boton1;
		private Sprite  boton2;
		private Sprite  boton3;
		private MusicManager music;
		private SDL.Surface icon;
		protected static SDL.Window window;
		private static SDL.Renderer render;
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
			SDL.quit();
			SDLTTF.quit();
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
			var splash = new Sprite(render,"img/splash.bmp", 0,0);
			var seleccion = new Sprite(render,"img/selector.bmp",0,0);
			Sprite botones[5];
			if(splash.actual_frame== null){ 
				GLib.error("Unable to load resource: %s\n", SDL.get_error());
			}

			splash.draw();
			for (int i = 0; i < 5; i++){
				botones[i] = new Sprite(render,"img/boton"+(i+1).to_string()+".bmp",0,0);
				botones[i].place.x=SCREEN_WIDTH/2;
				botones[i].place.y=ey;
				ey+= SCREEN_WIDTH/12;
				if(botones[i].actual_frame == null){// En caso de no cargarse alguna imagen, con malévolos motivos de depuración
					GLib.error("Unable to load button resource %d: %s\n", i, SDL.get_error());
				}
				botones[i].actual_frame.set_color_mod(255, 255, 255);
				botones[i].draw();
			}
			seleccion.place.x= botones[0].place.x;
			seleccion.place.y= botones[0].place.y;
			seleccion.place.h= botones[0].place.h;
			seleccion.place.w= botones[0].place.w;
			seleccion.actual_frame.set_alpha_mod(150);
			seleccion.draw();
			const string posnam = "position";
			seleccion.set_data<uint16>(posnam, 0);
			for (SDL.Event event = {0}; event.type != SDL.EventType.QUIT; Event.poll (out event)){
				render.present();
				switch (event.type) {
					case EventType.KEYDOWN:
						switch ( event.key.keysym.sym ){
						case SDL.Keycode.ESCAPE:
							// ESC key was pressed
							return;
							break;
						case SDL.Keycode.UP:
							if(seleccion.get_data<uint16>(posnam) == 0){
								break;
							}else{
								seleccion.set_data<uint16>(posnam,seleccion.get_data<uint16>(posnam) -1);
								seleccion.place.y -=40;
								render.present();
							}
							break;
						case SDL.Keycode.DOWN:
							if (seleccion.get_data<uint16>(posnam) ==4){
								break;
							}else{
								seleccion.set_data<uint16>(posnam,seleccion.get_data<uint16>(posnam) +1);
								seleccion.place.y +=40;
								render.present();
							}
							break;
						case SDL.Keycode.RETURN:
							switch (seleccion.get_data<uint16>(posnam)){
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
									instruccion();
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
			window = new Window("Space Fight", SDL.Window.POS_CENTERED, SDL.Window.POS_CENTERED, SCREEN_WIDTH, SCREEN_HEIGHT, SDL.InitFlag.EVERYTHING);
			if (window == null) {
				GLib.error("Failed to start: Are you sure there is a SDL2 lib on your system?");
			}
			SDLImage.init(SDLImage.InitFlags.ALL);
			render = SDL.Renderer.get_from_window(window); 
			icon = new SDL.Surface.from_bmp ("img/icono.bmp");
			window.set_icon(icon);
			SDL.GL.set_attribute(SDL.GLattr.DOUBLEBUFFER, 1);
		}

		public void init_music(){
			music = MusicManager.instance;
			
		}

		private void instruccion(){
			bool check = true;
			var text = new Sprite(render,"img/instrucciones.bmp",0,0);
			if(text.actual_frame== null){ 
				GLib.error("Unable to load image: %s\n", SDL.get_error());
			}
			text.draw();
			render.present();
			window.update_surface ();
			for (SDL.Event e = {0}; e.type != SDL.EventType.QUIT; Event.poll (out e)){
				render.present ();
				window.update_surface ();
			}
		}
	}
}
