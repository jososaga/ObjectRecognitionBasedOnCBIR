function mapclass_cans = create_mapping_cans()
keySet_cans = [1 2 3 5 8 10 12 13 14 15 16 17];
valueSet_cans = cell (numel(keySet_cans), 1);
for i=1:numel(keySet_cans)
    final_class_temp = sprintf('%05d', keySet_cans(i));
    valueSet_cans{i} = ['prod' final_class_temp '000'];
end
mapclass_cans = containers.Map(keySet_cans,valueSet_cans);
