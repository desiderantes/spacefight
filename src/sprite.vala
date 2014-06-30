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
using SDLImage;
using GLib;
namespace SpaceFight{
	public struct Frame{	
		private SDL.Texture texture;
		public Frame (string path, SDL.Renderer render) {
			texture = SDLImage.load_texture(render, path);
		}
		public SDL.Texture? img{ get{return texture;}}
	}
	public class Sprite : Object {

		private uint16 state;//The actual frame
		private uint16 cont;
		private uint16 nframes;//Number of frames
		private Frame[] sprite;
		public bool active {get;set;}
		public SDL.Rect place{get;set;}
		public Frame? actual_frame{get{return this.sprite[state];}}
		private SDL.Renderer? render;
		public uint8 movement = 1;

		// Constructor
		public Sprite (string path, int x = 0,int  y = 0, SDL.Renderer? render = null) {
			sprite = new Frame[1];
			nframes = 1;
			sprite[0] = Frame(path, render);
			cont = 0;
			state = 1;
			active = true;
			place.x = x;
			place.y = y;
			int access;
			SDL.PixelRAWFormat format;
			sprite[0].img.query(out format, out access, out place.w, out place.h); 
			this.render = render;
		}
		public Sprite.from_empty(uint16 nc = 1, SDL.Renderer? render = null){
			sprite = new Frame[nc];
			nframes = nc;
			cont = 0;
			state = 1;
			active = true;
			this.render = render;
			place.w = 0;
			place.h = 0;
			place.x = 0;
			place.y = 0;
		}
		public Sprite.from_pathlist(string[] pathlist, SDL.Renderer? render = null){
			sprite = new Frame[pathlist.length];
			nframes = pathlist.length as uint16;
			active= true;
			cont = 0;
			state = 1;
			for (int i = 0; i < pathlist.length; i++) {
				sprite[i] = Frame(pathlist[i], render);
				place.x = 0;
				place.y = 0;
				int access;
				SDL.PixelRAWFormat format;
				sprite[0].img.query(out format, out access, out place.w, out place.h);
			}
			this.render = render;
		}

		/* Method definitions */

		public void add_frame (Frame frame) {
			if(cont < nframes){
				sprite[cont] = frame;
				cont++;
				state = cont+ 1;
				int h;
				int w;
				int access;
				SDL.PixelRAWFormat format;
				sprite[cont].img.query(out format,out access,out w,out h);
				if(place.w < w){
					place.w = w;
				}
				if (place.h < h){ 
					place.h = h;
				}
			}
			else {
				sprite = new Frame[nframes];
			}
		}

		public void add_img(string path){
			if(cont < nframes){
				sprite[cont] = Frame(path, this.render);
				int h;
				int w;
				int access;
				SDL.PixelRAWFormat format;
				sprite[cont].img.query(out format,out access,out w,out h);
				if(place.w < w){
					place.w = w;
				}
				if (place.h < h){ 
					place.h = h;
				}
				cont++;
				state = cont+ 1;

			}
			else {
				sprite = new Frame[1];
				sprite[0] = Frame(path, this.render);
				int h;
				int w;
				int access;
				SDL.PixelRAWFormat format;
				sprite[cont].img.query(out format,out access,out w,out h);
				place.w = w; 
				place.h = h;
				cont++;
				state = cont+ 1;
			}
		}
		public void select_frame (uint16 nf) {
			if(nf <= cont){
				state = nf;
			}
		}
		public int frames () {
			return cont;
		}
		public void draw ( SDL.Renderer renderer = this.render, SDL.Rect? srcrect = null) {
			renderer.copy(sprite[state].img, srcrect, place);
			
		}
		public void animate( SDL.Renderer renderer = this.render, SDL.Rect? srcrect = null){
			
			if(nframes > 1){
				if (state == nframes){
					select_frame(1);
				}else{
					select_frame(state+1);
				}
				
			}
			this.draw(renderer, srcrect);
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
