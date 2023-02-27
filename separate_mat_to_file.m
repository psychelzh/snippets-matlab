function separate_mat_to_file(file, opts)
arguments
    file {mustBeFile}
    opts.ByColumn {mustBeNumericOrLogical} = true
    opts.OutDir {mustBeFolder} = fileparts(file)
    opts.UseSubdir {mustBeNumericOrLogical} = true
    opts.DataName {mustBeTextScalar} = 'g_sub_all'
end
[~, filename] = fileparts(file);
data_loaed = load(file);
data = data_loaed.(opts.DataName);
out_dir = opts.OutDir;
if opts.UseSubdir
    out_dir = fullfile(out_dir, "sublist");
    if ~exist(out_dir, "dir")
        mkdir(out_dir)
    end
end

if opts.ByColumn
    dim = 2;
else
    dim = 1;
end
for id = 1:size(data, dim)
    sub_tbl = extract_subid(data, id, dim);
    writetable(sub_tbl, fullfile(out_dir, sprintf('%s_%dthFold.txt', filename, id)), 'Delimiter', '\t')
end
end




function sub_tbl = extract_subid(sub_pool, id, dim)

if dim == 1
    sub_list = sub_pool(id, :);
else
    sub_list = sub_pool(:, id);
end
sub_list = reshape(sub_list, length(sub_list), 1);
sub_tbl = table(sub_list, sub_list, 'VariableNames', ["FID", "IID"]);

end
