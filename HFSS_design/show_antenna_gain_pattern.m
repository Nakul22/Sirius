function show_antenna_gain_pattern()
    close all; clear all; clc;

    % Load s11 data file
    s11_data = readtable("./s_11.csv");
    s11_frequencies = s11_data.Freq_GHz_;
    s11_db = s11_data.dB_St_Patch_1_T1_Patch_1_T1____;

    figure;
    plot(s11_frequencies, s11_db, 'LineWidth', 3);
    ylim([-30, -5]);
    xlim([0.65, 1.15]);
    xlabel("Frequency (GHz)");
    ylabel("S11 (dB)");
    set(gca, 'FontSize', 24);
    grid on;
    grid minor;
    box on;
    title("S11(db) vs Frequency");


    pattern_phitheta = [];
    amplitude_type = "linear";
    [pattern_phitheta(1,:,:), phi, theta] = read_hfss_exported_pattern("config_1.csv", amplitude_type);
    [pattern_phitheta(2,:,:), phi, theta] = read_hfss_exported_pattern("config_2.csv", amplitude_type);
    [pattern_phitheta(3,:,:), phi, theta] = read_hfss_exported_pattern("config_3.csv", amplitude_type);
    [pattern_phitheta(4,:,:), phi, theta] = read_hfss_exported_pattern("config_4.csv", amplitude_type);

    % Show polar plot of the radiation patterns
    plot_polar = true;
    plotting_angles_H = [1:length(phi)];
    plotting_angles_E = [1:length(theta)];
    for plotting_angles_H = [1]
        for config_number = 1:4
            figure;
            if(plot_polar)
                pax = polaraxes;
            end
            current_pattern = squeeze(pattern_phitheta(config_number,plotting_angles_E, plotting_angles_H));
            current_pattern = circshift(current_pattern, 90);
            size(current_pattern);
            polarplot(deg2rad(phi), current_pattern, 'LineWidth', 5, 'color', '#DF362D');
            rlim([50, 1.1*max(current_pattern)]);
            set(gca, 'FontSize', 20);
            title("Gain Pattern (Number " + config_number + ")");
        end
    end
end

function [pattern_phitheta, phi, theta] = read_hfss_exported_pattern(filename, amplitude_type)
    opts = delimitedTextImportOptions("NumVariables", 3);
    
    % Specify range and delimiter
    opts.DataLines = [2, Inf];
    opts.Delimiter = ",";
    
    % Specify column names and types
    opts.VariableNames = ["phi", "theta", "pattern_phitheta"];
    opts.VariableTypes = ["double", "double", "double"];
    
    % Specify file level properties
    opts.ExtraColumnsRule = "ignore";
    opts.EmptyLineRule = "read";
    
    % Import the data
    hfssTable = readtable(filename, opts);

    % Extract data from table
    pattern_phitheta = hfssTable.pattern_phitheta;
    phi = hfssTable.phi;
    theta = hfssTable.theta;

    pattern_phitheta = reshape(pattern_phitheta, [361, 361])';
    phi = 0:360;
    theta = 0:360;
    if(amplitude_type == "db")
        pattern_phitheta = 10.*log(pattern_phitheta);
    end
end