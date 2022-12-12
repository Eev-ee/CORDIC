--https://en.wikipedia.org/wiki/CORDIC

local ldexp = math.ldexp
local atan = math.atan
local pi = math.pi

local N = 50 --Numbers of iteration

local angles = {}
local KValues = {}

local p = 1/2^0.5
for i = 1, N do
	angles[i] = atan(ldexp(1, -(i - 1)))
	if (i + 1) <= N then
		KValues[i] = p
		p = p/(1 + ldexp(1, -2*i))^0.5
	end
end

local function cordic( beta ) --Calculates cos(beta) and sin(beta)
	if beta < -pi/2 or beta > pi/2 then
		local x, y = beta < 0 and cordic(beta + pi) or cordic(beta - pi)
		return -x, -y
	end

	local Kn = KValues[N - 1]
	local x, y = 1, 0
	local angle = angles[1]

	for j = 0, N - 1 do
		local sigma = beta < 0 and -1 or 1
		local tx = x - sigma*ldexp(y, -j)
		local ty = sigma*ldexp(x, -j) + y
		x, y = tx, ty
		beta = beta - sigma*angle

		if j + 2 > N then
			angle = angle / 2
		else
			angle = angles[j + 2]
		end
	end

	return x*Kn, y*Kn
end
local angle = math.rad(75)
print(cordic(angle))
print(math.cos(angle), math.sin(angle))
