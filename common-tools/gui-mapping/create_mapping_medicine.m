function mapclass_medicine = create_mapping_medicine()
keySet_medicine = [1:18];
valueSet_medicine = cell (numel(keySet_medicine), 1);
for i=1:numel(keySet_medicine)
    final_class_temp = sprintf('%05d', keySet_medicine(i));
    valueSet_medicine{i} = ['prod' final_class_temp '000'];
end
mapclass_medicine = containers.Map(keySet_medicine,valueSet_medicine);
