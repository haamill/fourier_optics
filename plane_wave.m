clear;
clc;

wave_vector = [1, 0];
frequency = 2 * pi;
delt_t = 0.1;
t_max = 10;
filename = 'plane_wave.gif';
[x_grid, y_grid] = meshgrid(-10:0.1:10, -10:0.1:10);

figure;
h = imagesc(x_grid(1,:), y_grid(:,1), zeros(size(x_grid)));
colorbar;
clim([-1 1]);
xlabel('x');
ylabel('y');
title('plane wave');

for time = 0:delt_t:t_max
    % electric field
    E_real = real(exp(1i*(wave_vector(1) * x_grid + wave_vector(2) * y_grid - frequency * time)));
    
    % 更新图形
    set(h, 'CData', E_real);
    drawnow;

    frame = getframe(gcf);
    img = frame2im(frame);
    [imind, cm] = rgb2ind(img, 256);
    
    % write to GIF
    if time == 0
        imwrite(imind, cm, filename, 'gif', 'Loopcount', inf, 'DelayTime', delt_t);
    else
        imwrite(imind, cm, filename, 'gif', 'WriteMode', 'append', 'DelayTime', delt_t);
    end
end