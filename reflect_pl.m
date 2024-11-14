clc;
clear;

incident = pi/6;
refrac_index = 1.5;
z_axis = -5:0.01:5;
x_axis = -5:0.01:5;
[z_grid,x_grid] = meshgrid(z_axis,x_axis);
amplitude = 1;
wave_number = 2*pi;
wavenumber_z = wave_number*cos(incident);
wavenumber_x = wave_number*sin(incident);
wavenumber_zp = sqrt((wave_number/refrac_index)^2-wavenumber_x^2);
% rs=sin(i2-incident)/sin(incident+i2);
% ts=2*cos(incident)/(cos(incident)+1.5*cos(i2));

E_I = amplitude.*exp(1i*(wavenumber_z.*(z_grid)+wavenumber_x.*x_grid)).*(z_grid<=0);
E_R = amplitude.*exp(1i*(-wavenumber_z.*(z_grid)+wavenumber_x.*x_grid)).*(z_grid<=0);
E_T = amplitude.*exp(1i*(wavenumber_zp.*(z_grid)+wavenumber_x*x_grid)).*(z_grid>0);
E_Left = E_I+E_R;
E_left = real(E_Left);
E_T = real(E_T);
E = E_T+E_left;

figure;
surf(z_axis,x_axis,E);
colorbar;
view(0,90);
shading interp;