/* -*- Mode: vala; tab-width: 4; intend-tabs-mode: t -*- */
/* spacefight.c
 * spacefight.vala
 * Copyright (C) Mario Daniel Ruiz Saavedra 2013 <desiderantes@rocketmail.com>
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
using SDLGraphics;
using SDLMixer;
namespace SpaceFight{
	public class SpaceFight : Application {
		private Sprite  boton1;
		private Sprite  boton2;
		private Sprite  boton3;
		private Music background_music;
		private SDL.Surface icon;
		private SDL.Window window;
		private SDL.Renderer render;
		private const uint16 SCREEN_WIDTH = 800;
		private const uint16 SCREEN_HEIGHT = 600;
		private const uint16 SCREEN_BPP = 24;
		private const uint8 DELAY = 10;
		private uint16 ex=SCREEN_WIDTH / 40;


		public SpaceFight(){
			init_video ();
			init_music ();
		}
		
		public static int main (string[] args) 
		{
			SDL.init(InitFlag.EVERYTHING);
			var app = new SpaceFight();
			app.run();
			SDL.quit ();

			return 0;
		}
		private void run(){
			menu();
		}
		private void menu(){
			uint16 ex=SCREEN_WIDTH / 40;
			uint16 ey =(SCREEN_HEIGHT/10) * 6 as uint16;
			bool good = true;
			var splash = new Sprite("img/splash.bmp");
			var seleccion = new Sprite("img/selector.bmp");
			Sprite botones[5];
			if(splash.img== null){ // En caso de no cargarse la imagen, advertimos al usuario
				stdout.printf(stderr, "No se ha podido cargar la imagen: %s\n", SDL.GetError());
				SDL.quit();
			}

			splash.draw(window);
			for (i = 0; i < 5; i++){
				botones[i] = new Sprite("img/boton"+(i+1).to_string()+".bmp");
				botones[i].place.x=SCREEN_WIDTH/2;
				botones[i].place.y=ey;
				ey+= SCREEN_WIDTH/12;
				if(botones[i].place == null){// En caso de no cargarse alguna imagen, con malévolos motivos de depuración
					GLib.error("No se ha podido cargar la imagen para el boton %d: %s\n", i, SDL.GetError());
					return EXIT_FAILURE;
				}
				botones[i].actual_frame().img.set_colorkey(SDL_SRCCOLORKEY | SDL_RLEACCEL, SDL.PixelFormat.map_rbga(255, 255, 255,255));
				botones[i].draw(window);
			}
			seleccion.place.x= botones[0].place.x;
			seleccion.place.y= botones[0].place.y;
			seleccion.place.h= botones[0].place.h;
			seleccion.place.w= botones[0].place.w;
			seleccion.actual_frame().set_alpha(SDL_SRCALPHA|SDL_RLEACCEL,150);
			seleccion.draw(window);
			const string posnam = "posicion";
			seleccion.set_data<uint8>(posnam, 0);
			while (good){
				SDL.Event event;
				while (event.poll() == 1) {
					window.flip();
					switch (event.type) {
						case EventType.QUIT:
							good = false;
							break;
						case EventType.KEYDOWN:
							switch ( event.key.sym )
						{
							case SDL.KeySymbol.ESCAPE:
								// ESC key was pressed
								good = false;
								SDL.quit();
								break;
							case SDL.KeySymbol.UP:
								if(seleccion.get_data(posnam) == 0){
									break;
								}else{
									seleccion.set_data(posnam,seleccion.get_data(posnam) -1);
									seleccion.place.y -=40;
									window.flip();
								}
								break;
							case SDL.KeySymbol.DOWN:
								if (seleccion.get_data(posnam) ==4){
									break;
								}else{
									seleccion.set_data(posnam,seleccion.get_data(posnam) +1);
									seleccion.place.y +=40;
									window.flip();
								}
								break;
							case SDL.KeySymbol.RETURN:
								switch (seleccion.get_data(posnam)){
									case 0:
										level = 1;
										var game = new Game(1, window);
										game.run();
										splash.draw(window);
										window.flip();
										break;
									case 1:
										level = 2;
										var game = new Game(2, window);
										game.run();
										splash.draw(window);
										window.flip();
										break;
									case 2:
										level = 3;
										var game = new Game(3, window);
										game.run();
										splash.draw(window);
										window.flip();
										break;
									case 3:
										instruccion();
										splash.draw(window);
										window.flip();
										break;
									case 4:
										good = false;
										SDL.quit();//Nos salimos del juego
										break;
									default:
										break;
								}

							default:
								break;
						}
					}                
					break;
				}
			}


		}
		private void init_video() {	
			window = new Window("Space Fight", SDL.Window.POS_CENTERED, SDL.Window.POS_CENTERED, SCREEN_WIDTH, SCREEN_HEIGHT, EVERYTHING)
			if (this.window == null) {
				GLib.error("Failed to star: Are you sure there is a SDL2 lib on your system?");
			}
			render = new Renderer.from_window(window, 
			icono.load(new RWops("img/icono.bmp", rb), 0);
			window.set_icon(icono);
			SDL.GL.set_attribute(SDL.GLattr.DOUBLEBUFFER, 1);
		}

		public void init_music(){
			if(SDLMixer.open(22050, AUDIO_S16, 2, 4096)){
				GLib.error("Error loading audio: %s \n", SDL.get_error());
				SDL.quit();
			}
			musica = new SDLMixer.Music("sounds/Realintro.mid");
			musica.volume(100);
			musica.play(-1);
		}

		private void instruccion(){
			bool check = true;
			var text = new Sprite("img/instrucciones.bmp");
			if(text.img== null){ // En caso de no cargarse la imagen, advertimos al usuario
				GLib.error("No se ha podido cargar la imagen: %s\n", SDL.get_error());
				SDL.quit();
			}
			text.draw(render);
			render.present();
			while (check){
				SDL.Event event1;
				while (event1.poll() == 1) {
					screen.flip();
					switch (event1.type) {
						case EventType.QUIT:
							check = false;
							break;
						case EventType.KEYDOWN:
							check = false;
							break;	
					}
				}
			}
		}
	}
}
