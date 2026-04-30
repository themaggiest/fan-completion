-- polynomial ring
R_k4 = QQ[x1, x2, x3, x4, x5]

-- polynomial
f_k4 = x1*x2*x3+x2^2*x3+x2*x3^2+x1^2*x4+x1*x2*x4+x1*x3*x4+x2*x3*x4+x1*x4^2+x1*x3*x5+x2*x3*x5+x1*x4*x5+x2*x4*x5+x1*x2+x2*x3+x1*x4+x3*x4+x1*x5+x2*x5+x3*x5+x4*x5+x5^2+x5

-- polytope
P_k4 = newtonPolytope(f_k4)

-- complete fan
F_k4 = normalFan(P_k4)
