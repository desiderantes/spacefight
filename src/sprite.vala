/* -*- Mode: vala; tab-width: 4; intend-tabs-mode: t -*- */
/* sprite.c
 * sprite.vala
 * Copyright (C) Mario Daniel Ruiz Saavedra 2013 <desiderantes@rocketmail.com>
 * SpaceFight is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * spacefight is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
using SDL;
using GLib;
namespace SpaceFight{
	public struct Frame{

		private unowned SDL.Surface img{get;set;}

		public void load (string path) {
			img.load(new RWops(path, rb), 0);
			img.set_colorkey(SDL_SRCCOLORKEY|SDL_RLEACCEL, 1 );
		}
		public void unload () {
			img.unref();
		}
	}


	public class Sprite : Object {
		private uint8 state;
		private uint8 cont;
		private uint8 nframes;
		private Frame[]? sprite;
		private bool active {get;set;}
		private SDL.Rect place{get;set;}

		// Constructor
		public Sprite (string path, int x = 0,int  y = 0) {
			sprite = Frame[1];
			nframes = 1;
			sprite[0].load(path);
			cont = 0;
			state = 1;
			active = true;
			place.x = 0;
			place.y = y;
			place.w = sprite[0].img.w;
			place.h = sprite[0].img.h;
		}
		public Sprite.from_empty(int nc = 1){
			sprite = new Frame[nc];
			nframes = nc;
			cont = 0;
			state = 1;
			active = true;
			place.w = 0;
			place.h = 0;
			place.x = 0;
			place.y = 0;
		}
		//Destructor
		~Sprite(){
			for(int i = 0; i < nframes; i++){
				sprite[i].unload();
			}	
		}

		/* Method definitions */

		public void add_frame (Frame frame) {
			if(cont < nframes){
				sprite[cont] = frame;
				cont++;
				state = cont+ 1;
				if(place.w < frame.img.w){
					place.w = frame.img.w;
				}
				if (place.h < frame.img.h){ 
					place.h = frame.img.h;
				}
			}
			else {
				sprite = new Frame[nframes];
			}
		}

		public void add_img(string path){
			if(cont < nframes){
				sprite[cont] = Frame();
				sprite[cont].load(path);
				if(place.w < sprite[cont].img.w){
					place.w = sprite[cont].img.w;
				}
				if (place.h < sprite[cont].img.h){ 
					place.h = sprite[cont].img.h;
				}
				cont++;
				state = cont+ 1;

			}
			else {
				sprite = new Frame[1];
				sprite[0].load(path);
				place.w = sprite[0].img.w; 
				place.h = sprite[0].img.h;
				cont++;
				state = cont+ 1;
			}
		}
		public void select_frame (int nf) {
			if(nf <= cont){
				state = nf;
			}
		}
		public int frames () {
			return cont;
		}
		public void draw (SDL.Rect srcrect = null, SDL.Surface dst) {
			sprite[state].img.blit(srcrect, dst, place);
		}

		public Frame actual_frame(){
			return sprite[state];
		}
		public bool colision (Sprite sp) {
			int w1, h1, w2, h2, x1, x2, y1, y2;

			w1 = this.place.w;
			h1 = this.place.h;
			x1 = this.place.x;
			y1 = this.place.y;

			w2 = sp.place.w;
			h2 = sp.place.h;
			x2 = sp.place.x;
			y2 = sp.place.y;

			if(((x1 + w1) > x2) && ((y1 + h1) > y2) && ((x2 + w2) > x1) && ((y2 + h2) > y1)){
				this.active = false;
				return true;
			} else {
				return false;
			}
		}

	}
}