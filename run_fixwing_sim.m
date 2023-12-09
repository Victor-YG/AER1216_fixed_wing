clc
clear
clear all

% run("parameters.m")

sim("Fixed_Wing_Aircraft_Sim_closed_loop.slx")
t = x_sim.Time;

x = x_sim.Data(:, 1);
y = x_sim.Data(:, 2);
z = x_sim.Data(:, 3);
h = -1 * z;
u = x_sim.Data(:, 4);
v = x_sim.Data(:, 5);
w = x_sim.Data(:, 6);
phi = x_sim.Data(:, 7);
theta = x_sim.Data(:, 8);
psi = x_sim.Data(:, 9);
p = x_sim.Data(:, 10);
q = x_sim.Data(:, 11);
r = x_sim.Data(:, 12);

de = u_sim.Data(:, 1);
da = u_sim.Data(:, 2);
dr = u_sim.Data(:, 3);
dt = u_sim.Data(:, 4);

figure
subplot(4, 1, 1)
plot(t, de)
legend("de")
grid on

subplot(4, 1, 2)
plot(t, da)
legend("da")
grid on

subplot(4, 1, 3)
plot(t, dr)
legend("dr")
grid on

subplot(4, 1, 4)
plot(t, dt)
legend("dt")
grid on

figure
subplot(4, 3, 1)
plot(t, x)
legend("x")
grid on

subplot(4, 3, 2)
plot(t, y)
legend("y")
grid on

subplot(4, 3, 3)
plot(t, h)
legend("h")
grid on

subplot(4, 3, 4)
plot(t, u)
legend("u")
grid on

subplot(4, 3, 5)
plot(t, v)
legend("v")
grid on

subplot(4, 3, 6)
plot(t, w)
legend("w")
grid on

subplot(4, 3, 7)
plot(t, phi)
legend("phi")
grid on

subplot(4, 3, 8)
plot(t, theta)
legend("theta")
grid on

subplot(4, 3, 9)
plot(t, psi)
legend("psi")
grid on

subplot(4, 3, 10)
plot(t, p)
legend("p")
grid on

subplot(4, 3, 11)
plot(t, q)
legend("q")
grid on

subplot(4, 3, 12)
plot(t, r)
legend("r")
grid on


