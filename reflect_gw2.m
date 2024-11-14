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
index = 0;
E_L = zeros(1000,1000);
E_R = zeros(1000,1000);
for wavenumber_xi = wavenumber_x
    index = index + 1;
    wavenumber_zi = wave_number * sqrt(1 - (wavenumber_xi / wave_number)^2);
    wavenumber_znew = -wavenumber_xi*sin(theta)+wavenumber_zi*cos(theta);
    wavenumber_xnew = wavenumber_xi*cos(theta)+wavenumber_zi*sin(theta);
    % rs = sin(theta_t-theta_i)/sin(theta_t+theta_i);
    % ts = 2*cos(theta_i)/(refrac_index1*cos(theta_i)+refrac_index2*cos(theta_t));
    EI = abs(E0_f(index))*exp(1i * (wavenumber_xi.*(-z_grid*sin(theta)+x_grid*cos(theta))+wavenumber_zi.*abs(distance+z_grid*cos(theta)+x_grid*sin(theta)))).*(z_grid<=0);
    ER = abs(E0_f(index))*exp(1i * (wavenumber_xi.*(z_grid*sin(theta)+x_grid*cos(theta))+wavenumber_zi.*abs(distance-z_grid*cos(theta)+x_grid*sin(theta)))).*(z_grid<=0);
    ET = abs(E0_f(index))*exp(1i * (sqrt((wave_number*refrac_index1/refrac_index2)^2-wavenumber_xnew^2).*z_grid+wavenumber_xnew.*x_grid+wavenumber_zi*distance)).*(z_grid>0);
    E_L = E_L + EI + ER;
    E_R = E_R + ET;
end

E_real = real(E_L);                                                                                  

figure;
surf(z_axis,x_axis,E_real);
colorbar;
view(0,90);
shading interp;