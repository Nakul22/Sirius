function evaluate_localization()
    close all; clear all; clc;

    all_x_coordinates = [];
    all_y_coordinates = [];
    all_x_ground_truth = [];
    all_y_ground_truth = [];
    all_distance_errors = [];

    for x_coord = [0:1:7]
        for y_coord = [1:1:7]
            filename = "./estimated_aoas/"+num2str(x_coord)+"_"+num2str(y_coord)+".mat";
            if(isfile(filename))
                [estimated_x, estimated_y, ground_truth_x, ground_truth_y, distance_errors] = get_location_for_this_coord(filename, x_coord, y_coord);
                all_x_coordinates = [all_x_coordinates estimated_x];
                all_y_coordinates = [all_y_coordinates estimated_y];
                all_x_ground_truth = [all_x_ground_truth ground_truth_x];
                all_y_ground_truth = [all_y_ground_truth ground_truth_y];
                all_distance_errors = [all_distance_errors distance_errors];
            end
        end
    end

    localization_cdf_plots(all_x_coordinates, all_y_coordinates, all_x_ground_truth, all_y_ground_truth, all_distance_errors);
end


function [estimated_x, estimated_y, ground_truth_x, ground_truth_y, distance_errors] = get_location_for_this_coord(filename, x_coord, y_coord)
    load(filename, "angle_ap1", "angle_ap2", "num_experiments");
    
    estimated_y = [];
    estimated_x = [];
    ground_truth_y = [];
    ground_truth_x = [];
    distance_errors = [];
    for kk = 1:num_experiments
        % Perform triangulation
        estimated_y(kk) = 7*3/(abs(tand(angle_ap1(kk))) + abs(tand(angle_ap2(kk))));
        estimated_x(kk) = estimated_y(kk)*abs(tand(angle_ap1(kk)));

        % 3meter steps per unit
        ground_truth_y(kk) = 3*y_coord;
        ground_truth_x(kk) = 3*x_coord;

        % Calculate localization error
        current_error = get_distance_error(estimated_x(kk), estimated_y(kk), ground_truth_x(kk), ground_truth_y(kk));
        distance_errors(kk) = current_error;
        kk= kk + 1;
    end
end

function [distance_error] = get_distance_error(estimated_coordinates_x, estimated_coordinates_y, ground_truth_x, ground_truth_y)
    distance_error = sqrt(((estimated_coordinates_x - ground_truth_x)^2) + ((estimated_coordinates_y - ground_truth_y)^2));
end

function localization_cdf_plots(all_x_coordinates, all_y_coordinates, all_x_ground_truth, all_y_ground_truth, all_distance_errors)
    for kk = 1:length(all_x_coordinates)
        current_error_x = abs(all_x_coordinates(kk) - all_x_ground_truth(kk));
        if(~isnan(current_error_x))
            all_x_errors(kk) = current_error_x;
        end

        current_error_y = abs(all_y_coordinates(kk) - all_y_ground_truth(kk));
        if(~isnan(current_error_y))
            all_y_errors(kk) = current_error_y;
        end
    end

    figure; hold on;
    [h, stats] = cdfplot(all_x_errors);
    stats
    set(h, 'LineWidth', 2, 'LineStyle', '-', 'Color', 'b');

    [h, stats] = cdfplot(all_y_errors);
    stats
    set(h, 'LineWidth', 2, 'LineStyle', '-', 'Color', 'r');

    [h, stats] = cdfplot(all_distance_errors);
    stats
    set(h, 'LineWidth', 3, 'LineStyle', '-', 'Color', 'k');

    legend(["error in x", "error in y", "Overall error"], 'location', 'east');

    FontSize = 24;
    set(gca, 'FontSize', FontSize);
    xlabel("Localization error (m)");
    ylabel("CDF");
    grid on;
    xlim([0, 30]);
    title("");
end