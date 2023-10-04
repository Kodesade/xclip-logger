`stty -echo`
print `tput civis`

lastClip = nil
HISTPATH = File.expand_path("~/.xcliphistory")
LOGFILE = File.open(HISTPATH,File::RDWR+File::CREAT+File::TRUNC+File::BINARY)
begin
  loop do
    clipboard = `xclip -o -selection 'clipboard' 2> /dev/null`
    
    if clipboard != lastClip and $?.exitstatus == 0 then
      print(`tput clear` << "\e[3J" << `tput cup 0 0`) #]
      LOGFILE.seek(0,:SET)

      raw_history = LOGFILE.read
      history = raw_history.split("\u0003")
      
      dup_idx = history.index(clipboard)
      if dup_idx then history = history[0...dup_idx] + history[dup_idx+1..-1] end
      
      history << clipboard

      raw_history = history.join("\u0003")
      
      LOGFILE.seek(0,:SET)
      LOGFILE.truncate(0)
      LOGFILE.write(raw_history)
      
      puts history.join("\n---\n")
      
      lastClip = clipboard
    end
    
    sleep 0.1
  end
rescue Interrupt
  `stty echo`
  print `tput cnorm`
  exit 0
end
