clear;
clc;

% Parameter settings
width_gaussian_wave = 1;
amplitude = 1;
wave_number = 2*pi;
z_axis = linspace(-10, 10, 1000);
sampling_num = 50; % sampling frequency
x_axis = linspace(-10, 10, sampling_num*20); % sampling range
electricfield_space = [];
angular_freq = 2*pi;
delt_t = 0.01;

% Initial Gaussian wave
eletric_field = amplitude*exp(-x_axis.^2 / width_gaussian_wave^2);

% Fourier transform
electricfield_wavenumber = fftshift(fft(eletric_field));

% Frequency grid
wave_number_x = 2*pi.*linspace(-sampling_num/2, sampling_num/2, sampling_num*20);

for distance = z_axis
    % Propagation in Fourier space
    transfer_fun = exp(1i * abs(distance) *wave_number* sqrt(1 - (wave_number_x / wave_number).^2)); % Angular spectrum transfer function
    electricfield_wavenumber_d = electricfield_wavenumber .* transfer_fun;

    % Inverse Fourier transform
    electricfield_d = ifft(ifftshift(electricfield_wavenumber_d));
    electricfield_space = vertcat(electricfield_space, electricfield_d);
end

electricfield_space = transpose(electricfield_space);

% Spatial grid (x, y)
[z_axis, x_axis] = meshgrid(z_axis, x_axis);

% 创建一个图形窗口
figure;

% 定义GIF文件名
filename = 'gaussian_wave.gif';

% 生成动画帧
for t = 0:delt_t:1
    % 绘制图形
    electricfield_space = electricfield_space*exp(1i*angular_freq*t);
    electricfield_space = real(electricfield_space);
    imagesc(z_axis(1,:), x_axis(:,1), electricfield_space);
    drawnow;
    
    % 捕获当前帧
    frame = getframe(gcf);
    im = frame2im(frame);
    [imind, cm] = rgb2ind(im, 256);
    
    % 写入GIF文件
    if t == 0
        imwrite(imind, cm, filename, 'gif', 'Loopcount', inf, 'DelayTime', delt_t);
    else
        imwrite(imind, cm, filename, 'gif', 'WriteMode', 'append', 'DelayTime', delt_t);
    end
end
