local ldexp = math.ldexp
local atan2 = math.atan2
local pi = math.pi

local N = 55 --Numbers of iteration

local angles = {}
local KValues = {}

local p = 1/2^0.5
for i = 1, N do
	angles[i] = atan2(1, ldexp(1, i - 1))
	if (i + 1) <= N then
		KValues[i] = p
		p = p/(1 + ldexp(1, -2*i))^0.5
	end
end

local function cordic( beta ) --Calculates cos(beta), sin(beta), and the error
	if beta < -pi/2 or beta > pi/2 then
		local x, y, err
		if beta < 0 then
			x, y, err = cordic(beta + pi)
		else
			x, y, err = cordic(beta - pi)
		end
		return -x, -y, err
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

	local co = x*Kn
	local si = y*Kn

	return co, si, 1 - (co*co + si*si)^0.5
end
local angle = 180
print(cordic(angle))
print(math.cos(angle), math.sin(angle))
