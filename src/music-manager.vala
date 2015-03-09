/* -*- Mode: vala; tab-width: 4; intend-tabs-mode: t -*- */
/* music-manager.c
 * music-manager.vala
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

using SDL;
using GLib;
using SDLMixer;

namespace SpaceFight{

	public class MusicManager{

		private static MusicManager hidden_inst;
		private SDLMixer.Music background_music;
		private SDLMixer.Channel channels;
		public static MusicManager instance{
			get{ 
				lock(hidden_inst){
					if(hidden_inst == null){
						hidden_inst = new MusicManager();
					}
				}
				return hidden_inst;
			}
		}

		private MusicManager(){
			if(SDLMixer.open(44100,SDL.Audio.Format.S16LSB,2,4096) != 0){
				GLib.error("Error loading audio: %s \n", SDL.get_error());
			}
			background_music = new SDLMixer.Music("sfx/background.ogg");
			channels = SDLMixer.Channel.allocate(2);
			Music.volume(100);
			background_music.play(-1);
		}

		public void emit_sfx(string sound_path, uint8 volume = 0){
			unowned SDLMixer.Chunk? sfx = ResourceManager.instance.get_sound(sound_path);
			sfx.volume(volume);
			channels.play(sfx,0);
		}

		public void toggle_background(){
			if(Music.is_paused()){
				Music.resume();
			}else{
				Music.pause();
			}
		}

		public void toggle_background_fading(uint8 ms){
			//TODO: actual fading of background music
			if(Music.is_paused()){
				Music.resume();
			}else{
				Music.pause();
			}
		}		
	}
}
