x = 1920 --Width of application
y = 1080 --Heigh of application
love.window.setMode(x, y)
circlex = x/2
circley = y/2
computery = y/2
computerchange = 0 
playery = y/2
playerchange = 0 
base_radius = 30
ballspeed = 3
changex = 1 * ballspeed
changey = 1 * ballspeed
Cpoints = 0
Ppoints = 0
count = {0, 0}
math.randomseed(os.time())

function pongdraw()
    love.graphics.circle("fill", circlex, circley, base_radius)
    love.graphics.print("Enemy tactic:" .. count[2] .. " " .. count[1] .. " " .. computery, x/2, 10)
    love.graphics.print("Ball x:" .. circlex .. " Ball y:" .. circley .. " Ball speed:" .. ballspeed, x*0.25, 10)
    love.graphics.print("Player points:" .. Ppoints .. " Computer points:" .. Cpoints, x*0.75, 10)
    playersquare()
    computersquare()
    movecircle()
    circlechange()
end

function playersquare()
    skey = love.keyboard.isDown( 's' )
    wkey = love.keyboard.isDown( 'w' )
    if skey == true then
        playerchange = 3
    elseif wkey == true then
        playerchange = -3
    end
    playery = playery + playerchange
    if playery + 100 > y then
        playery = y - 100
    elseif playery < 0 then
        playery = 0
    end
    love.graphics.rectangle("fill", 20, playery, 10, 100 )
    playerchange = 0
end

function computersquare()
    computerchange = docomputershitt(math.random(4))
    computery = computery + computerchange
    if computery + 100 > y then
        computery = y - 100
    elseif computery < 0 then
        computery = 0
    end
    love.graphics.rectangle("fill", x - 30, computery, 10, 100 )
    computerchange = 0
end

function movecircle()
    circlex = circlex + 1 * changex
    circley = circley + 1 * changey
end

function circlechange()
    if circley - base_radius == 0 then
        changey = 1 * ballspeed
    elseif circley + base_radius == y then
        changey = -1 * ballspeed
    elseif circley + base_radius > playery and circley - base_radius < playery + 100 and circlex - base_radius == 30 then
        changex = 1 * ballspeed
    elseif circley + base_radius > computery and circley - base_radius < computery + 100 and circlex + base_radius == x - 30 then
        changex = -1 * ballspeed 
    end

    if circlex - base_radius == 0 or circlex + base_radius == x then
        if circlex - base_radius == 0 then 
            Cpoints = Cpoints + 1
        else
            Ppoints = Ppoints + 1
        end
        circlex = x/2
        circley = y/2
        computery = y/2
        playery = y/2
        choice = {-1, 1}
        changey = choice[math.random(#choice)] * ballspeed
        changex = choice[math.random(#choice)] * ballspeed
    end
end 


function docomputershitt(key)
    if count[1] < 1 then
        if key == 1 then
            count[2] = 1
            count[1] = math.random(150)
        elseif key == 2 then
            count[2] = 2
            count[1] = math.random(y*0.25, y*0.75)
        else
            count[2] = 3
            count[1] = math.random(600)
        end
    end
    if count[2] == 1 then 
        count[1] = count[1] - 1
        return 0
    elseif count[2] == 2 then
        if count[1] > computery + 3 then
            return 3
        elseif count[1] < computery - 3 then
            return -3
        else
            count[1] = 0
            return 0
        end
    else 
        if circley > computery then 
            count[1] = count[1] - 1
            return 3
        else
            count[1] = count[1] - 1 
            return -3
        end
    end
end