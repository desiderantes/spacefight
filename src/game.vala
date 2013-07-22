/* -*- Mode: vala; tab-width: 4; intend-tabs-mode: t -*- */
/* game.c
 * game.vala
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
namespace SpaceFight{
	public class Game : GLib.Object {
		private const uint8 SCREEN_WIDTH = 800;
		private const uint8 SCREEN_HEIGHT = 600;
		private const uint8 SCREEN_BPP = 24;
		private const uint8 DELAY = 10;
		private uint8 ex=SCREEN_WIDTH / 40;
		private uint8 ey= SCREEN_HEIGHT / 12;

		private SDL.Screen screen;
		private bool done;
		private Actor ship;
		private Sprite background;
		private GLib.List<Actor> enemies;
		private GLib.List<Shot> ship_shots;

		private SDL.Surface icon;
		private SDL.Surface image;
		private SDL.Rect dest;
		private SDL.Event event;
		private SDL.Key keys;


		private uint8 dead;
		private uint8 limit;
		private uint8 shots_left;

		public Game (uint8 level, unowned SDL.Screen screen, uint8 SCREEN_WIDTH, uint8 SCREEN_HEIGHT){
			uint8 ex = SCREEN_WIDTH / 50 as uint8;
			uint8 ey = SCREEN_HEIGHT / (40 / 3) as uint8; 
			limit = (level*level*20)-(level/2)+(level*level) as uint8;
			this.screen = screen;
			shots_left = limit + 8;
			dead = 0;
			load_sprites(ex, ey);
			done = false;
		}

		public void load_sprites(uint8 ex, uint8 ey){
			enemies = new GLib.List <Actor> ();
			for (uint8 i = 0; i < limit; i++){
				if (ex > SCREEN_WIDTH - (SCREEN_WIDTH / 40)){
					ex = SCREEN_WIDTH / 40;
					ey+= SCREEN_HEIGHT / 12;
				}
				if (ey > SCREEN_HEIGHT - (SCREEN_HEIGHT / 12)){
					ey = SCREEN_HEIGHT / 12;
				}
				en1 = new Actor ("img/enemies.bmp", ex, ey);


				if (en1.actual_frame().img = null){
					GLib.error("Error loading image: %s \n", SDL.get_error());
					SDL.quit();
				}

				en1.actual_frame().img.set_colorkey(SDL_SRCCOLORKEY | SDL_RLEACCEL,SDL.PixelFormat.map_rgb(90,53,53));
				enemies.append(en1);
				ex += SCREEN_WIDTH /(100/7) as uint8;
			}
			background= new Sprite ("img/background1.bmp");
			if(background.actual_frame().img = null){
				GLib.error("Error loading image: %s \n", SDL.get_error());
				SDL.quit();
			}
			ship = new Actor ("img/minave.bmp", SCREEN_WIDTH /2, SCREEN_HEIGHT - (SCREEN_HIEGHT / (15/2) ) as int );
			ship.actual_frame().img.set_colorkey(SDL_SRCCOLORKEY | SDL_RLEACCEL,SDL.PixelFormat.map_rgb(21,159,40));
			if (ship.actual_frame().img = null){
				GLib.error("Error loading image: %s \n", SDL.get_error());
				SDL.quit();
			}

		}
		public void run (){
			while (!done){
				background.draw(screen);
				ship.draw(screen);
				for (uint8 i = 0; i < limit; i++){
					en2 = enemies.nth_data(i);
					if(en2.active){
						en2.draw(screen);
						if(en2.place.x > (SCREEN_WIDTH - en2.place.w)){
							en2.place.x = en2.place.w;
							en2.place.y += en2.place.h;
						}else {en2.place.x +=5 ;}
						if(en2.place.y> (SCREEN_HEIGHT - en2.place.h * 3.5 )){
							this.end();
						}
					}
				}
				for (uint8 i = 0; i < ship_shots.length(); i++){
					tiro = ship_shots.nth_data(i);
					tiro.draw(screen);
					tiro.place.x += tiro.movement * 5 ;
					if(tiro.place.y <= 0 ){
						ship_shots.remove(tiro);
						tiro.unref();

					}
				}
			}
			process_events();
		}


		public void process_events(){
			SDL.Event event;
			while (event.poll() == 1) {
				screen.flip();
				switch (event.type) {
					case EventType.QUIT:
						done = true;
						break;
					case EventType.KEYDOWN:
						switch ( event.key.sym )
					{
						case SDL.KeySymbol.ESCAPE:
							// ESC key was pressed
							done = true;
							this.end();
							break;
						case SDL.KeySymbol.LEFT:
							if(ship.place.x > 0) {
								ship.place.x -=3;
							}
							break;
						case SDL.KeySymbol.RIGHT:
							if(ship.place.x  + ship.place.w < SCREEN_WIDTH) {
								ship.place.x +=3;
							}
							break;
						case SDL.KeySymbol.UP:
							if(ship.place.y > 0) {
								ship.place.y -= 5;
								if(ship.place.y < (SCREEN_HEIGHT - ship.place.h * 3.5 )){
									ship.place.y = SCREEN_HEIGHT - ship.place.h * 3.5 ;
								}
							}
							break;
						case SDL.KeySymbol.DOWN:
							if(ship.place.y + ship.place.h < SCREEN_HEIGHT) {
								ship.place.y += 5;
							}
							break;
						case SDL.KeySymbol.SPACE:
							ship.shoot(ship_shots);

						default:
							break;
					}
				}                
				break;
			}
		}

		public void end(){
		//FIXME Stub
		bool check = true;
			var text = new Sprite("img/perdiste.bmp");
			if(text.img== null){ // En caso de no cargarse la imagen, advertimos al usuario
				GLib.error("No se ha podido cargar la imagen: %s\n", SDL.get_error());
				SDL.quit();
			}
			text.draw(screen);
			screen.flip();
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

