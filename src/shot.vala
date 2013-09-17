/* -*- Mode: vala; tab-width: 4; intend-tabs-mode: t -*- */
/* shot.c
 * shot.vala
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

namespace SpaceFight{
	public class Shot: Sprite{
		private override int8 movement {get;set;}
		public Shot(uint16 x, uint16 y, bool move){
			if(move) {
				movement = -1;
			}else{ 
				movement = 1;
			}
			base("img/bala.bmp", x, y);
		}
	}
}