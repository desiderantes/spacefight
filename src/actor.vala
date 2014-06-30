/* -*- Mode: vala; tab-width: 4; intend-tabs-mode: t -*- */
/* actor.c
 * actor.vala
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

using SDL;
using GLib;
using SDLImage;
namespace SpaceFight{

	public class Actor : Sprite{
		public bool type;
		public Actor (string path, bool type = false, int x= 0, int y=0){
			base(path, x, y);
		}

		public virtual bool shoot( ref List<Shot> shot_list){
			try {
				shot_list.append( new Shot(this.place.x + (this.place.w / 2) as int, this.place.y, movement));
			}
			catch (GLib.Error e){
				GLib.debug(e.message);
				return false;
			}
			finally {return true;}
		}



	}
}
