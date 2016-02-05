/* -*- Mode: vala; tab-width: 4; intend-tabs-mode: t -*- */
/* sprite.c
 * sprite.vala
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
using SDL;
using SDLImage;
using GLib;
namespace SpaceFight{
	
	public class Sprite : Object {

		private uint16 state;//The actual frame
		private uint16 cont;
		private uint16 nframes;//Number of frames
		private (unowned Video.Texture?)[] sprite;
		public bool active {get;set;}
		public Video.Rect place{get;set;}
		public Video.Texture? actual_frame{get{return this.sprite[state];}}
		public unowned Video.Renderer render;
		public uint8 movement = 1;
		// Constructor
		public Sprite (Video.Renderer render, string id, int x = 0,int  y = 0 ) {
			sprite = new Video.Texture[1];
			nframes = 1;
			sprite[0] = ResourceManager.instance.get_image(id);
			cont = 0;
			state = 1;
			active = true;
			place.x = x;
			place.y = y;
			int w;
			int h;
			int access;
			Video.PixelRAWFormat format;
			sprite[0].query(out format, out access, out w, out h);
			place.w = w;
			place.h = h;
			this.render = render;
		}
		public Sprite.from_empty (Video.Renderer render,uint16 nc = 1, int x = 0, int y =0){
			sprite = new Video.Texture[nc];
			nframes = nc;
			cont = 0;
			state = 1;
			active = true;
			this.render = render;
			place.w = 0;
			place.h = 0;
			place.x = x;
			place.y =y;
		}
		public Sprite.from_idlist(Video.Renderer render,string[] idlist, int x =0, int y =0 ){
			this.render = render;
			sprite = new Video.Texture[idlist.length];
			nframes = (uint16) idlist.length;
			active= true;
			cont = 0;
			state = 1;
			foreach (string id in idlist) {
				this.add_frame(ResourceManager.instance.get_image(id));
			}
			
		}

		/* Method definitions */

		public void add_frame (Video.Texture frame) {
			if(cont < nframes){
				sprite[cont] = frame;
				cont++;
				state = cont+ 1;
				int h;
				int w;
				int access;
				Video.PixelRAWFormat format;
				sprite[cont].query(out format,out access,out w,out h);
				if(place.w < w){
					place.w = w;
				}
				if (place.h < h){ 
					place.h = h;
				}
			}
			else {
				sprite = new Video.Texture[nframes];
			}
		}

		public void add_img(string id){
			if(cont < nframes){
				sprite[cont] = ResourceManager.instance.get_image(id);
				int h;
				int w;
				int access;
				Video.PixelRAWFormat format;
				sprite[cont].query(out format,out access,out w,out h);
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
				sprite = new SDL.Texture[1];
				sprite[0] = ResourceManager.instance.get_image(id);
				int h;
				int w;
				int access;
				Video.PixelRAWFormat format;
				sprite[cont].query(out format,out access,out w,out h);
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
		public virtual void draw ( ) {
			render.copy(sprite[state], null, place);
			
		}
		public void animate(){
			
			if(nframes > 1){
				if (state == nframes){
					select_frame(1);
				}else{
					select_frame(state+1);
				}
				
			}
			this.draw();
		}

		public bool colision (Sprite sp) {
			if(this.place.is_intersecting(sp.place)){
				this.active = false;
				return true;
			} else {
				return false;
			}

		}
	}
}
