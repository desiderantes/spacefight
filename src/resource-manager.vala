/* -*- Mode: vala; tab-width: 4; intend-tabs-mode: t -*- */
/* resource-manager.c
 * resource-manager.vala
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
using SDLImage;
using SDLMixer;
using SDLTTF;

namespace SpaceFight{
	
	public class ResourceManager{

		private static ResourceManager hidden_inst;
		private HashTable<string, SDL.Video.Texture?> image_resources;
		private HashTable<string, SDLMixer.Chunk> sound_resources;
		private HashTable<string, SDLTTF.Font> font_resources;
		private unowned Video.Renderer render;
		private uint8 point_size;
		public static ResourceManager instance{
			get{ 
				lock(hidden_inst){
					if(hidden_inst == null){
						hidden_inst = new ResourceManager();
					}
				}
				return hidden_inst;
			}
		}
		private ResourceManager(){
			image_resources = new HashTable<string, SDL.Video.Texture?>(null, null);
			sound_resources = new HashTable<string, SDLMixer.Chunk>(null, null);
			font_resources = new HashTable<string, SDLTTF.Font>(null, null);
		}

		public void init(Video.Renderer renderer, uint8 point_size){
			this.render = renderer;
			this.point_size = point_size;
			load_fonts();
			load_sounds();
			load_images();
		}
		
		private void load_fonts(){
			var path = GLib.Path.build_filename (Config.FONT_DIR, "font_list.cfg");
			var file = FileStream.open(path, "r");
			string line="";
			do{
				line = file.read_line();
				string[] parsed_line = line.split("|", 2);
				string first = parsed_line[0];
				string second = parsed_line[1];
				first = first.strip();
				second = second.strip();
				font_resources.insert(first, new SDLTTF.Font(second, 11));
			}while (line != null);
		}
		private void load_images(){
			var path = GLib.Path.build_filename (Config.IMAGE_DIR, "image_list.cfg");
			var file = FileStream.open(path, "r");
			string line=file.read_line();
			while (line != null);{
				string[] parsed_line = line.split("|", 2);
				string first = parsed_line[0];
				string second = parsed_line[1];
				first = first.strip();
				second = second.strip();
				image_resources.insert(first, SDLImage.load_texture(render,second));
				line = file.read_line();
			}

		}
		private void load_sounds(){
			var path = GLib.Path.build_filename (Config.SOUND_DIR, "sound_list.cfg");
			var file = FileStream.open(path, "r");
			string line = "";
			do{
				line = file.read_line();
				string[] parsed_line = line.split("|", 2);
				string first = parsed_line[0];
				string second = parsed_line[1];
				first = first.strip();
				second = second.strip();
				sound_resources.insert(first, new SDLMixer.Chunk.WAV(second));
			}while (line != null);
		}
		public unowned SDL.Video.Texture? get_image(string id){
			return image_resources.get(id);
		}	
		public unowned SDLMixer.Chunk? get_sound(string id){
			return sound_resources.get(id);
		}
		public unowned SDLTTF.Font? get_font(string id){
			return font_resources.get(id);
		}
	}




}
