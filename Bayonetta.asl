// Credits Mysterion_06_
// Commission by TheScruffington

state("Bayonetta"){
    byte level: 0x56CBEEC;      // 255 = menu; 0-17 = ingame chapter
    byte loading: 0xAF5A70;     // 0 & 1 = loadings
    byte finish: 0xAFB785;      // 64 during fight and 192 when finishing the fight
    float timer: 0xB31518;      // random float value that works for the final split
}

start{
    //Starts upon choosing difficulty
    if(current.level == 0 && old.level == 255){
        return true;
    }
}

startup{
    //Asks the user to set his timer to game time on livesplit, which is needed for verification
    if (timer.CurrentTimingMethod == TimingMethod.RealTime) // Inspired by the Modern warfare 3 Autosplitter
    {        
        var timingMessage = MessageBox.Show (
            "This game uses Time without Loads (Game Time) as the main timing method.\n"+
            "LiveSplit is currently set to show Real Time (RTA).\n"+
            "Would you like to set the timing method to Game Time? This will make verification easier.",
            "LiveSplit | Bayonetta",
            MessageBoxButtons.YesNo,MessageBoxIcon.Question);
        if (timingMessage == DialogResult.Yes)
        {
            timer.CurrentTimingMethod = TimingMethod.GameTime;
        }
    }
}

/*init{
    //Signature scanning
    var pattern = new SigScanTarget("00 00 00 00 50 05 00 00 00 03 00 00 57 00 00 00 ?? ?? ?? ?? ?? ?? 00 00 ?? ?? 00 00");

    vars.gameOffset = IntPtr.Zero;
    int scanAttempts = 10;
    while (scanAttempts-- > 0)
    {
        foreach (var page in game.MemoryPages(true).Reverse())
        {
            var scanner = new SignatureScanner(game, page.BaseAddress, (int)page.RegionSize);
            if ((vars.gameOffset = scanner.Scan(pattern)) != IntPtr.Zero)
            {
                print("Found static Game members at 0x" + vars.gameOffset.ToString("X8"));
                scanAttempts = 0;
                break;
            }
        }
        if (scanAttempts == 0) break;
        print("Could not find pattern, retrying " + scanAttempts + " more times.");
        Thread.Sleep(1000);
    }

    if ((IntPtr)vars.gameOffset == IntPtr.Zero)
    print("Could not find pattern, Game version is likely unsupported.");

    //Current FPS
    vars.frames = new MemoryWatcher<byte>(vars.gameOffset + 0x1C);
}

update{
    //Updating the memory from the sig scan
    vars.frames.Update(game);

    //Setting the variable equal to the Current FPS found with the sig scan (Used to display FPS in Livesplit)
    vars.FPS = vars.frames.Current;
}*/

split{
    //Main chapter splitting
    if(current.level < old.level && current.level != 255){
        return true;
    }

    //Final split
    if(current.timer >= 11f && current.timer <= 12f && current.finish == 192 && old.finish == 64 && current.level == 17){
        return true;
    }
}

isLoading{
    //Stops during loading times
    if(current.loading == 1 || current.loading == 0){
        return true;
    } else{
        return false;
    }
}
