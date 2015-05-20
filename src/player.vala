/* -*- Mode: vala; tab-width: 4; intend-tabs-mode: t -*- */
/* player.c
 * player.vala
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

namespace SpaceFight{
	public enum PowerUp{
		FASTER,
		DUO,
		ULTRASHOT,
		SHIELD,
		NONE;
		
		public string to_string(){
			switch (this){
				case FASTER:
					return _("Speed Bump");
				case DUO:
					return _("Double Ship");
				case ULTRASHOT:
					return _("Wide Shot");
				case SHIELD:
					return _("Shield");
				case NONE:
					return _("None");
				default:
					GLib.assert_not_reached();
			}
		}
	}
	public class Player : Sprite, Actor {
		private uint8 damage;
		private uint8 damage_limit;
		private PowerUp power_up;
		private uint16 shot_counter;
		public Player(SDL.Renderer render, int x, int y ){
			this.power_up = PowerUp.NONE;
			this.shot_counter = 0;
			this.damage = 0;
			this.damage_limit = 3;
			base.from_idlist(render,{"player-normal","player-shield","player-damaged","player-duo","player-ultrashot","player-explosion"},x,y);	
		}
		public  bool shoot(List<Shot> shot_list){
			bool type = power_up == PowerUp.ULTRASHOT ? true : false;
			var shot = new Shot(this.render, (uint16)(this.place.x + (this.place.w / 2)), (uint16)this.place.y , type, false);
			shot_counter++;
			shot_list.append(shot);
			return true;
		}
	

	}

}
