lastClip = nil
HISTPATH = File.expand_path("~/.xcliphistory")
LOGFILE = File.open(HISTPATH,File::RDWR+File::CREAT+File::TRUNC)
begin
  loop do
    clipboard = `xclip -o -selection 'clipboard'`
    if clipboard != lastClip
      print `tput clear` << "\e[3J" << `tput cup 0 0`
      LOGFILE.write("%s\n" % clipboard)
      LOGFILE.seek(0,:SET)
      print LOGFILE.read
      lastClip = clipboard
    end
    sleep 0.1
  end
rescue Interrupt
  exit 0
end
