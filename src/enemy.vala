/* -*- Mode: vala; tab-width: 4; intend-tabs-mode: t -*- */
/* enemy.c
 * enemy.vala
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

namespace SpaceFight{
	public class Enemy : Sprite, Actor{

		public Enemy(Video.Renderer render, int x, int y){
			base.from_idlist(render,{"enemy-normal","enemy-damaged","enemy-explosion1","enemy-explosion2","enemy-super","enemy-superdamaged"},x,y);	
		}

		public bool shoot( List<Shot> shot_list){
			return false;
		}
		public override void draw(){
			render.copy(actual_frame, null, place);
			int w;
			int h;
			render.get_logical_size(out w, out h);
			if(this.place.x > (w - this.place.w)){
				this.place.x = (int)this.place.w;
				this.place.y += (int)this.place.h;
			}else{
				this.place.x +=5 ;
			}
		}	
	}
	
	
}
