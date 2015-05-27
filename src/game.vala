/* -*- Mode: vala; tab-width: 4; intend-tabs-mode: t -*- */
/* game.c
 * game.vala
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
	public class Game : GLib.Object {
		private const uint16 SCREEN_WIDTH = 800;
		private const uint16 SCREEN_HEIGHT = 600;
		private const uint16 SCREEN_BPP = 24;
		private const uint8 DELAY = 10;
		private uint16 ex=SCREEN_WIDTH / 40;
		private uint16 ey= SCREEN_HEIGHT / 12;

		private unowned SDL.Graphics.Renderer render;
		private bool done;
		private Player ship;
		private Background background;
		private GLib.List<Enemy> enemies;
		private GLib.List<Shot> ship_shots;
		public uint8 level;

		private uint8 dead;
		private uint8 limit;
		private uint8 shots_left;

		public Game (uint8 level, Graphics.Renderer render, uint16 SCREEN_WIDTH, uint16 SCREEN_HEIGHT){
			uint16 ex = SCREEN_WIDTH / 50;
			uint16 ey = SCREEN_HEIGHT / (40 / 3); 
			limit = (level*level*20)-(level/2)+(level*level);
			this.render = render;
			shots_left = limit + 8;
			dead = 0;
			this.level = level;
			load_sprites(ex, ey);
			done = false;
		}

		public void load_sprites(uint16 ex, uint16 ey){
			enemies = new GLib.List<Enemy> ();
			for (uint8 i = 0; i < limit; i++){
				if (ex > SCREEN_WIDTH - (SCREEN_WIDTH / 40)){
					ex = SCREEN_WIDTH / 40;
					ey+= SCREEN_HEIGHT / 12;
				}
				if (ey > SCREEN_HEIGHT - (SCREEN_HEIGHT / 12)){
					ey = SCREEN_HEIGHT / 12;
				}
				Enemy en = new Enemy (this.render, ex, ey);


				if (en.actual_frame == null){
					GLib.error("Error loading image: %s \n", SDL.get_error());
				}

				en.actual_frame.set_color_mod(90,53,53);
				enemies.append(en);
				ex += SCREEN_WIDTH /14;
			}
			background= new Background (this.render,"img/background1.bmp");
			if(background.actual_frame == null){
				GLib.error("Error loading image: %s \n", SDL.get_error());
			}
			ship = new Player (this.render, SCREEN_WIDTH /2, SCREEN_HEIGHT - (SCREEN_HEIGHT / (15/2) ) );
			ship.actual_frame.set_color_mod(21,159,40);
			if (ship.actual_frame == null){
				GLib.error("Error loading image: %s \n", SDL.get_error());
			}

		}
		public void run (){
			while (!done){
				background.draw();
				ship.draw();
				foreach(Enemy en in enemies){
					en.draw();
				}
				
			
				for(uint8 i = 0; i < ship_shots.length(); i++){
					Shot tiro = ship_shots.nth_data(i);
					tiro.draw();
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
			for (SDL.Event event = {0}; event.type != SDL.EventType.QUIT; Event.poll (out event)){	
				render.present();
				switch (event.type) {
					case EventType.KEYDOWN:
						switch ( event.key.keysym.sym ){
							case Input.Keycode.ESCAPE:
								// ESC key was pressed
								done = true;
								this.end();
								break;
							case Input.Keycode.LEFT:
								if(ship.place.x > 0) {
									ship.place.x -=3;
								}
								break;
							case Input.Keycode.RIGHT:
								if(ship.place.x  + ship.place.w < SCREEN_WIDTH) {
									ship.place.x +=3;
								}
								break;
							case Input.Keycode.UP:
								if(ship.place.y > 0) {
									ship.place.y -= 5;
									if(ship.place.y < (SCREEN_HEIGHT - ship.place.h * 3.5 )){
										ship.place.y = (int)(SCREEN_HEIGHT - ship.place.h * 3.5);
									}
								}
								break;
							case Input.Keycode.DOWN:
								if(ship.place.y + ship.place.h < SCREEN_HEIGHT) {
									ship.place.y += 5;
								}
								break;
							case Input.Keycode.SPACE:
								ship.shoot(ship_shots);
								break;

							default:
								break;
						}
					break;
				}                
			}
		}

		public void end(){
			//FIXME Not complete
			var text = new Sprite(render,"img/perdiste.bmp",0,0 );
			if(text.actual_frame== null){ // En caso de no cargarse la imagen, advertimos al usuario
				GLib.error("Unable to load end background: %s\n", SDL.get_error());
			}
			text.draw();
			render.present();
			for (SDL.Event e = {0}; e.type != SDL.EventType.QUIT || e.type != SDL.EventType.KEYDOWN; Event.poll (out e)){
				render.present();
			}
		}
	}	  
}

