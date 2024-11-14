clear;
clc;

% Parameter settings
width_gaussian_wave = 1; % Width of the Gaussian wave
amplitude = 1;
wave_number = 2*pi; % Wave number
z_axis = linspace(-10, 10, 1000);
x_axis = linspace(-10, 10, 1000);
[z_grid, x_grid] = meshgrid(z_axis, x_axis); % Space grid
sampling_num = 50; % Sampling frequency
theta = pi/6;
refrac_index1 = 1;
refrac_index2 = 1.5;
distance = 5; % distance of OO'

% Initial Gaussian wave
E0 = amplitude*exp(-x_axis.^2 / width_gaussian_wave^2);

% Fourier transform
E0_f = fftshift(fft(E0));

% Frequency grid
wavenumber_x = 2*pi*linspace(-sampling_num/2, sampling_num/2, 1000);
wavenumber_x = wavenumber_x(481:520);
E0_f = E0_f(481:520);
E0_fp = 1/(2*sqrt(pi))*exp(-wavenumber_x.^2/4);
index = 0;
E_L = zeros(1000,1000);
E_R = zeros(1000,1000);
for wavenumber_xi = wavenumber_x
    index = index + 1;
    wavenumber_zi = wave_number * sqrt(1 - (wavenumber_xi / wave_number)^2);
    wavenumber_znew = -wavenumber_xi*sin(theta)+wavenumber_zi*cos(theta);
    wavenumber_xnew = wavenumber_xi*cos(theta)+wavenumber_zi*sin(theta);
    EI = E0_fp(index)*exp(1i * (wavenumber_xnew.*(x_grid+3)+wavenumber_znew.*(z_grid+3))).*(z_grid<=0);
    ER = E0_fp(index)*exp(1i * (wavenumber_xnew.*(x_grid+3)-wavenumber_znew.*(z_grid-3))).*(z_grid<=0);
    ET = E0_fp(index)*exp(1i * (wavenumber_xnew.*(x_grid+3)+sqrt(wave_number^2-wavenumber_xnew^2).*z_grid+wavenumber_znew*3)).*(z_grid>0);
    E_L = E_L + EI + ER;
    E_R = E_R + ET;
end

E_real = real(E_L+E_R);                                                                                  

figure;
surf(z_axis,x_axis,E_real);
colorbar;
view(0,90);
shading interp;