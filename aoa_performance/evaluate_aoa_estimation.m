function evaluate_aoa_estimation()
    close all; clear all; clc;

    % Test data filename
    test_data_filename = "./collected_data.mat";

    % Load dataset
    load(test_data_filename, "ml_features_test", "ground_truth_angles_test");

    % Trained model filename
    model_filename = "./model_900mhz_4switches.mat";

    % Load model
    load(model_filename, "net_regression");

    angle_index_output = 1;
    shape_ml_features = size(ml_features_test);
    for angle_index_input = 1:shape_ml_features(4)
        predicted_answer_regression = predict(net_regression, ml_features_test(:,:,1,angle_index_input));
        predicted_answer(angle_index_output) = predicted_answer_regression;
        actual_angles(angle_index_output) = ground_truth_angles_test(angle_index_input);
        angle_index_output = angle_index_output + 1;
    end

    angle_errors = abs(actual_angles-predicted_answer);

    this_angle_errors = [];
    this_angle_predictions = [];
    unique_angles = 0;
    for all_angles_category = 0:10:170
        c = 0;
        for i = 1:length(actual_angles)
            if(actual_angles(i)==all_angles_category)
                this_angle_predictions(unique_angles+1, c+1) = predicted_answer(i);
                this_angle_errors(unique_angles+1, c+1) = angle_errors(i);
                c = c + 1;
            end
        end
        [all_angles_category, c];
        unique_angles = unique_angles + 1;
    end
    median_prediction_per_angle = median(this_angle_predictions, 2);
    std_errors_per_angle = std(this_angle_errors, 0, 2);


    % ----------CDF plot----------
    figure;
    [h, ~] = cdfplot(angle_errors);
    FontSize = 24;
    set(gca, 'FontSize', FontSize);
    xlabel("AoA error (deg)");
    ylabel("Empirical CDF");
    grid on;
    title("");
    set(h, 'LineWidth', 4, 'LineStyle', '-', 'Color', 'k');
    xlim([0, 60]);
    xticks([0:10:80]);

    % ----------angle vs error scatter plot----------
    figure; hold on;
    errorbar([0:10:10*length(median_prediction_per_angle)-1], median_prediction_per_angle, std_errors_per_angle/2, std_errors_per_angle/2, 'x', 'MarkerSize', 8, 'MarkerEdgeColor','red', 'MarkerFaceColor', 'red', 'LineWidth', 2, 'color', 'r');
    plot([0:10:10*length(median_prediction_per_angle)-1], [0:10:170], 'LineStyle', '--', 'color', 'k', 'LineWidth', 2)
    grid on;
    FontSize = 24;
    set(gca, 'FontSize', FontSize);
    xticks([0:20:180]);
    yticks([0:20:180]);
    xlabel("Ground truth angles (deg)");
    ylabel("Estimated angles (deg)");
    xlim([-10, 180]);
    ylim([-10, 180]);
    legend(["Estimates", "Ground truth"], 'location', 'best');
end