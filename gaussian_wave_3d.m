clear;
clc;

% Parameter settings
width_gaussian_wave = 1;
amplitude = 1;
wave_number = 2*pi;
z_axis = linspace(-5, 5, 250);
x_axis = linspace(-5, 5, 250);
y_axis = linspace(-5, 5, 250);
[x_grid,y_grid] = meshgrid(x_axis,y_axis);
[x_3dgrid, y_3dgrid, z_3dgrid] = meshgrid(x_axis, y_axis, z_axis);
electricfield_space = 0;
angular_freq = 2*pi;
delt_t = 0.01;

% Gaussian wave
electric_field = amplitude*exp((-x_grid.^2 - y_grid.^2)/ width_gaussian_wave^2);
wavenumber_xy = 2*pi.*linspace(-1,1,50);
electricfield_wavenumber = 1/(4*pi)*exp(-(wavenumber_xy.^2)/4);

index = 0;
for wavenumber_xyi = wavenumber_xy
    index = index+1;
    for theta = linspace(0,2*pi,50)
        electricfield_space = electricfield_space+electricfield_wavenumber(index)*exp(1i*(wavenumber_xyi*cos(theta)*x_3dgrid+wavenumber_xyi*sin(theta)*y_3dgrid+sqrt(wave_number^2-wavenumber_xyi^2)*z_3dgrid))*0.0316;
    end
end

% 创建一个图形窗口
figure;
slice(x_3dgrid,y_3dgrid,z_3dgrid,real(electricfield_space),[],[],-5:0.5:5);
alpha color; % set transparency
alpha scaled;
colorbar;
shading interp;
