x = 1920 --Width of application
y = 1080 --Heigh of application
World = love.physics.newWorld()
tiles = {32, 18}
point_tiles = {}
points = 0
pacx = tiles[1] / 2
pacy = tiles[2] / 2
Pacman = {}
Pacman.Shape = love.physics.newRectangleShape(pacx * (x / tiles[1]), pacy * (y / tiles[2]), 50, 50)
Pacman.Body = love.physics.newBody(World, pacx * (x / tiles[1]), y - pacy * (y / tiles[2]), "dynamic")

move_dir = 0
available_dir = {true, true, true, true}
love.window.setMode(x, y)
length = {0,0,0,0}
roadmap = {}

num_nav = {}
function getpointtiles()
    local i = 1
    for i=1,tiles[1] do
        point_tiles[i] = {}
        for k=1,tiles[2] do
            point_tiles[i][k] = false
        end
    end
end
getpointtiles()

function worldRayCastCallback(fixture, x, y, xn, yn, fraction)
	local hit = {}
	hit.fixture = fixture
	hit.x, hit.y = x, y
	hit.xn, hit.yn = xn, yn
	hit.fraction = fraction

	table.insert(Ray.hitList, hit)

	return 1 -- Continues with ray cast through all shapes.
end

function love.load()
    Pacman.Fixture = love.physics.newFixture(Pacman.Body, Pacman.Shape)
    -- Setting this to 1 to avoid all current scaling bugs.
	love.physics.setMeter(1)

	Terrain = {}
	Terrain.Body = love.physics.newBody(World, 0, 0, "static")
	Terrain.Stuff = {}
	mapgen()
    --maptest()

	Ray = {
		x1 = 0,
		y1 = 0,
		x2 = 0,
		y2 = 0,
		hitList = {}
	}

    for i=0,tiles[1] do
        roadmap[i] = 0
        if i == 3 then
            roadmap[i] = i
        end
    end
end

function love.update(dt)    
	local now = love.timer.getTime()

	World:update(dt)

	-- Clear fixture hit list.
	Ray.hitList = {}
	
	-- Calculate ray position.
	Ray.x1, Ray.y1, Ray.x2, Ray.y2 = pacx * (x / tiles[1]), y - pacy * (y / tiles[2]), pacx * (x / tiles[1]), y - pacy * (y / tiles[2])
	
	-- Cast the ray and populate the hitList table.
	World:rayCast(Ray.x1, Ray.y1, Ray.x2* 0, Ray.y2, worldRayCastCallback)
    World:rayCast(Ray.x1, Ray.y1, Ray.x2, Ray.y2* 0, worldRayCastCallback)
    World:rayCast(Ray.x1, Ray.y1, Ray.x2* 0 + x, Ray.y2, worldRayCastCallback)
    World:rayCast(Ray.x1, Ray.y1, Ray.x2, Ray.y2* 0 + y, worldRayCastCallback)

end

function love.draw()
    love.graphics.setColor(1, 1, 1)
	for i, v in ipairs(Terrain.Stuff) do
		if v.Shape:getType() == "polygon" then
			love.graphics.polygon("line", Terrain.Body:getWorldPoints( v.Shape:getPoints() ))
		elseif v.Shape:getType() == "edge" then
			love.graphics.line(Terrain.Body:getWorldPoints( v.Shape:getPoints() ))
		else
			local x, y = Terrain.Body:getWorldPoints(v.x, v.y)
			love.graphics.circle("line", x, y, v.Shape:getRadius())
		end
	end

    -- Drawing the ray.
	love.graphics.setLineWidth(3)
	love.graphics.setColor(1, 1, 1, .4)
	love.graphics.line(Ray.x1, Ray.y1, Ray.x2*0, Ray.y2)
	love.graphics.line(Ray.x1, Ray.y1, Ray.x2, Ray.y2*0)
	love.graphics.line(Ray.x1, Ray.y1, Ray.x2*0 + x, Ray.y2)
	love.graphics.line(Ray.x1, Ray.y1, Ray.x2, Ray.y2*0 + y)
	love.graphics.setLineWidth(1)

	-- Drawing the intersection points and normal vectors if there were any.
	for i, hit in ipairs(Ray.hitList) do
		love.graphics.setColor(1, 0, 0)
		love.graphics.print(i, hit.x, hit.y) -- Prints the hit order besides the point.
		love.graphics.circle("line", hit.x, hit.y, 3)
		love.graphics.setColor(0, 1, 0)
		love.graphics.line(hit.x, hit.y, hit.x + hit.xn * 25, hit.y + hit.yn * 25)
        -- Temp 02
	end

    love.graphics.print("1:" .. tostring(available_dir[1]) .. " 2:" .. tostring(available_dir[2]) .. " 3:" .. tostring(available_dir[3]) .. " 4:" .. tostring(available_dir[4]), x * 0.75, 10)
    love.graphics.print("X:" .. x .. " X Tiles:" .. tiles[1] .. " X Tilesize:" .. x / tiles[1], x/2, 10)
    love.graphics.print("Y:" .. y .. " Y Tiles:" .. tiles[2] .. " Y Tilesize:" .. y / tiles[2], x/2, 20)
    love.graphics.print("Pac X:" .. pacx * (x / tiles[1]) .. " Pac X Tile:" .. pacx, x/4, 10)
    love.graphics.print("Pac Y:" .. y - pacy * (y / tiles[2]) .. " Pac Y Tile:" .. pacy, x/4, 20)
    tilegen()
    keypress()
    pacmanmove()
    availablecheck()
end

function maptest()
    for i = 1, tiles[1] do
        for k = 1, tiles[2] do
            love.graphics.rectangle("line",i*(x / tiles[1]), k* (y / tiles[2]), 10, 10)
        end
    end
end

function mapgen()
    -- Cleaning up the previous stuff.
	for i = #Terrain.Stuff, 1, -1 do
		Terrain.Stuff[i].Fixture:destroy()
		Terrain.Stuff[i] = nil
	end

	-- Generates some random shapes.
	for i = 1, tiles[1] do
		local p = {}
		p.x, p.y = math.random(1, tiles[1]), math.random(1, tiles[2])
		local w, h = x / tiles[1], y / tiles[2]
        p.Shape = love.physics.newRectangleShape(p.x * (x / tiles[1]), p.y * (y / tiles[2]), w, h)
		p.Fixture = love.physics.newFixture(Terrain.Body, p.Shape)
		Terrain.Stuff[i] = p
        point_tiles[p.x][p.y] = false
        if roadmap[p.x] == p.y then
            Terrain.Stuff[i] = nil
            Terrain.Stuff[i].Fixture:destroy()
            point_tiles[p.x][p.y] = true
        end
	end
end
function tilegen()
    for i=1,tiles[1] do
        for k=1,tiles[2] do
            if point_tiles[i][k] == true then
                love.graphics.circle("fill",i * (x / tiles[1]),k * (y / tiles[2]), x / tiles[1] / 5)
            end
        end
    end
end
function keypress()
    if love.keyboard.isDown( 'w' ) and available_dir[1] == true then
        move_dir = 1
    elseif love.keyboard.isDown( 'a' ) and available_dir[2] == true then
        move_dir = 2
    elseif love.keyboard.isDown( 'd' ) and available_dir[3] == true then
        move_dir = 3
    elseif love.keyboard.isDown( 's' ) and available_dir[4] == true then
        move_dir = 4
    end

    if love.keyboard.isDown( 'e' ) or available_dir[move_dir] == false then
        move_dir = 0
    end
end

function pacmanmove()
    if move_dir == 1 then
        pacy = pacy + 0.05
    elseif move_dir == 2 then
        pacx = pacx - 0.05
    elseif move_dir == 3 then
        pacx = pacx + 0.05
    elseif move_dir == 4 then
        pacy = pacy - 0.05
    end

    if pacx > tiles[1] + 1 then
        pacx = -1
    elseif pacx < -1 then
        pacx = tiles[1] + 1
    end

    if pacy > tiles[2] + 1 then
        pacy = -1
    elseif pacy < -1 then
        pacy = tiles[2] + 1
    end
    if point_tiles[math.floor(pacx)][tiles[2] - math.floor(pacy)] == true then 
        point_tiles[math.floor(pacx)][tiles[2] - math.floor(pacy)] = false
        points = points + 10
    end
end

function availablecheck()
    
end