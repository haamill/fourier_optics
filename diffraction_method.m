clc;
clear;

width_gaussian_wave = 1; % Width of the Gaussian wave
amplitude = 1;
x_axis = linspace(-10, 10, 1000);
y_axis = linspace(-10, 10, 1000);
electric_field = zeros(1000,1000);

%E0 = A*exp(-y0.^2 / omega^2);

for index_x = 1:n
    for index_y = 1:n
        fun = @(y0) -1i*x_axis(index_x)*(x_axis(index_x)^2+(y_axis(index_y)-y0).^2).^(-3/4)*0.5*amplitude.*exp(-y0.^2 / width_gaussian_wave^2).*exp(1i*2*pi.*sqrt((x_axis(index_x)^2+(y_axis(index_y)-y0).^2)));
        electric_field(index_x,index_y) = integral(fun, -2, 2);
    end
end

electric_field = real(electric_field);
electric_field = transpose(electric_field);
figure;
surf(x_axis,y_axis,E_real);
colorbar;
view(0,90);
shading interp;