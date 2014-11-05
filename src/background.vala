/* -*- Mode: vala; tab-width: 4; intend-tabs-mode: t -*- */
/* background.c
 * background.vala
 * Copyright (C) Mario Daniel Ruiz Saavedra 2013 - 2014 <desiderantes@rocketmail.com>
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
using GLib;
using SDLImage;
namespace SpaceFight{

	public class Background : Sprite{
	
		public Background(SDL.Renderer render, string tilepath){
			base(render, tilepath,0,0);
		}

		public override void draw(){
			//TODO: Moving the background
			var tile_rect = this.place;
			int w;
			int h;
			render.get_logical_size(out w, out h);
			do{
				render.copy(actual_frame, null, tile_rect);
				if(tile_rect.x > w){
					tile_rect.x = 0;
					tile_rect.y += tile_rect.h;
				} else{
					tile_rect.x += tile_rect.w;
				}
				
			}while(tile_rect.y < h);
		}
	}
}