Key = class()

function Key:init(name,x,y,width,height,colour)
    -- you can accept and set parameters here
    self.name = name
    self.width = width
    self.height = height
    self.x = x
    self.y = y
    self.pressed = false
    if colour == "White" then
        self.colour = color(255, 255, 255, 255)
    else
        self.colour = color(0, 0, 0, 255)
    end
    
end

function Key:draw()
    -- Codea does not automatically call this method
        -- Draw keys   
    pushStyle()
        
        if table.contains(gtHeldNotes,self.name) == true then
            self.pressed = true
        else
            self.pressed = false
        end
        
        if self.pressed == true then 
            fill(255, 0, 0, 255) -- red if pressed
            else
            fill(self.colour)
        end
            
        stroke(0, 0, 0, 255)
        strokeWidth(2)
        rectMode(CENTER)          
        rect(self.x,self.y,self.width,self.height)
        
    popStyle()
end

