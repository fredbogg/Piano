-- Scale.  This script makes a diatonic keyboard that plays polyphonically
-- By Fred.
-- v2.0

-- Use this function to perform your initial setup
supportedOrientations(LANDSCAPE_ANY)

function setup()
    --displayMode(FULLSCREEN)
    soundBufferSize(5)
        -- This is the amount you need to multiply a note value by to get the next highest one.
    -- Don't ask me why it's not in hertz, it hurts.
    multiplier = 1.0296
    
    pitchTable = {1} -- This table will be filled with the note values
    pitch = pitchTable[1]
    semitoneModifier = 0
    
 --   gsNoteOrder = "CDEFGABcdefgab"
    gsTonalSystem = "22122212212221" -- compared with the noteOrder, this shows the no of 
                                  --  semitones between each note, like the black and white keys.
   
    -- There are 88 keys on a piano, so we will start from our highest note and go down.
    -- We calculate the notes ourselves and put them in a table. 
    for i = 88, 1, -1 do
        pitch = pitch / multiplier
        table.insert(pitchTable,1,pitch)
    end

    gnWhiteKeys=8
    
    gtTouches={}
    gtHeldNotes={}
    
    gtKeyTable = {}
    local lnNoteNumber
    -- eight pairs of black and white notes except 3 and 7
    for i = 1, 8 do
        
        lnNoteNumber = convertWhiteKey(i)
        
          
              -- name,x,y,width,height,colour
            --  white
        gtKeyTable[lnNoteNumber] = 
            Key(lnNoteNumber,(i-0.5)*(WIDTH/gnWhiteKeys),HEIGHT/2,WIDTH/gnWhiteKeys,400,"White")
            
            -- black
            if string.sub(gsTonalSystem,i,i) ~= "1" then 
            gtKeyTable[lnNoteNumber+1] = 
    Key(lnNoteNumber+1,(i)*(WIDTH/gnWhiteKeys),HEIGHT/2+100,WIDTH/gnWhiteKeys*(0.75),200,"Black")
            end
    end
    
end

function convertWhiteKey(key)

    local lnNoteNumber = 1
        -- notes 2,4,7,9 and 11 should be black
         -- 1,3,5,6,8,10,12,13
      
            local lsCumulativeSemitones = string.sub(gsTonalSystem,1,key-1)
            
            if key > 1 then
                local j
                for j = 1, #lsCumulativeSemitones do
                    lnNoteNumber = lnNoteNumber + tonumber(string.sub(lsCumulativeSemitones,j,j))
                end
                
            end
        return lnNoteNumber

end

function touched(touch)
    
    if touch.state == ENDED then
        gtTouches[touch.id] = nil
    else
        gtTouches[touch.id] = touch        
    end
   
    gtHeldNotes={}
    
    local k
    local touch
    for k,touch in pairs(gtTouches) do
        
        local x = touch.x
        
        local y = touch.y
        local lnNotePressed
 
        if y > HEIGHT/2 then
          -- black note
            lnNotePressed = math.ceil((x - (WIDTH/gnWhiteKeys)/4) / WIDTH * gnWhiteKeys )
            lnNotePressed = convertWhiteKey(lnNotePressed) +1
            if lnNotePressed == 6 or lnNotePressed == 13 then
                lnNotePressed = lnNotePressed - 1
            end
        else
          -- white note
            lnNotePressed = math.ceil(x/WIDTH*gnWhiteKeys)
            lnNotePressed = convertWhiteKey(lnNotePressed)
        end
       
        if lnNotePressed > 0 then
            table.insert(gtHeldNotes,lnNotePressed)
        end
        
    end   
    
end

-- This function gets called once every frame
function draw()
    
    background(0, 0, 0, 255) 
    -- draw white notes first
    local i
    for i = 1, #gtKeyTable do
        if i ~= 2 and i ~= 4 and i ~= 7 and i ~= 9 and i ~=11 and i ~= 14 then
            gtKeyTable[i]:draw()
        end
    end
    -- draw black notes on top
    for i = 1, #gtKeyTable do
        if i == 2 or i == 4 or i == 7 or i == 9 or i == 11 or i == 14 then
            gtKeyTable[i]:draw()
        end
    end

    
    for k,v in pairs(gtHeldNotes) do
        playSound(v)
    end
   
end

function playSound(noteNumber)
    local lnNoteNumber = noteNumber
    lnNoteNumber = lnNoteNumber + 55
    local lnKeyPressed = pitchTable[lnNoteNumber]
    
sound({StartFrequency = lnKeyPressed, AttackTime = 0.369866, SustainPunch = 0.373787, DecayTime = 0.56842, MinimumFrequency = 0, Slide = 0.503199, DeltaSlide = 0.499278, VibratoDepth = 0.5, VibratoSpeed = 0.5, ChangeAmount = 0.5, ChangeSpeed = 0.5, SquareDuty = 0.828689, DutySweep = 0.5, RepeatSpeed = 0.5, PhaserSweep = 0.5, LowPassFilterCutoff = 1, LowPassFilterCutoffSweep = 0.5, LowPassFilterResonance = 0.5, HighPassFilterCutoff = 0.5, HighPassFilterCutoffSweep = 0.5, Waveform = 0})

 --   sound({StartFrequency = lnKeyPressed, SustainTime = 0.2, Waveform = 2})
   
end

function table.contains(table, element)
    local value
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
end