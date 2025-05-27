import cst
import cst.interface
import cst.results

Project_path = r"C:\study\LeetCode\LEETCODE\mario_rl-main\00.cst"

import sys

cst_lib_path = r"C:\study\CST Studio Suite 2022\AMD64\python_cst_libraries"
sys.path.append(cst_lib_path)


class CST_script():
    def __init__(self) -> None:
        self.cst_full_path = Project_path

    # 打开CST。若已经打开了，则判断是不是需要打开的项目
    def opencst(self):
        allpids = cst.interface.running_design_environments()
        is_open = False
        for pid in allpids:
            current_DE = cst.interface.DesignEnvironment.connect(pid)
            for project_path in current_DE.list_open_projects():
                # print(project_path)
                if self.cst_full_path == project_path:
                    current_project = current_DE.get_open_project(project_path)
                    is_open = True
                    break
        if not is_open:
            current_DE = cst.interface.DesignEnvironment()
            current_project = current_DE.open_project(self.cst_full_path)
            is_open = True
        return current_DE, current_project

    # # 更改变量
    # def change_para(self, para_name, para_value, CurrentProject):
    #     command = 'Sub Main ()\nStoreDoubleParameter("%s", "%.2f")\nRebuildOnParametricChange (bfullRebuild, bShowErrorMsgBox)\nEnd Sub' % (
    #     para_name, para_value)
    #     # 执行修改变量脚本
    #     res = CurrentProject.schematic.execute_vba_code(command, timeout=None)
    #     return res

    def material_init(self, matrix, r1, p, d):
        current_DE, current_project = self.opencst()
        cst.interface.DesignEnvironment.in_quiet_mode = False
        m = len(matrix)
        command = 'Sub Main ()\n'
        command += 'StoreDoubleParameter("%s", "%.2f")\n' % ("R1", r1)
        command += 'StoreDoubleParameter("%s", "%.2f")\n' % ("P", p)
        command += 'StoreDoubleParameter("%s", "%.2f")\n' % ("ta", d)
        command += 'RebuildOnParametricChange (bfullRebuild, bShowErrorMsgBox)\n'
        for i in range(m):
            for j in range(m):
                if matrix[i][j] == 1:
                    command += 'Solid.ChangeMaterial "component1:cell_%s_%s", "ITO"\n' % (i, j)
                    command += 'Solid.ChangeMaterial "component1:cell_%s_%s_1", "ITO"\n' % (i, j)
                    command += 'Solid.ChangeMaterial "component1:cell_%s_%s_2", "ITO"\n' % (i, j)
                    command += 'Solid.ChangeMaterial "component1:cell_%s_%s_3", "ITO"\n' % (i, j)
                else:
                    command += 'Solid.ChangeMaterial "component1:cell_%s_%s", "PET"\n' % (i, j)
                    command += 'Solid.ChangeMaterial "component1:cell_%s_%s_1", "PET"\n' % (i, j)
                    command += 'Solid.ChangeMaterial "component1:cell_%s_%s_2", "PET"\n' % (i, j)
                    command += 'Solid.ChangeMaterial "component1:cell_%s_%s_3", "PET"\n' % (i, j)
        command += 'End Sub'
        current_project.schematic.execute_vba_code(command, timeout=None)

        # 修改变量
        # command = 'Sub Main ()\nStoreDoubleParameter("%s", "%.2f")\nStoreDoubleParameter("%s", ' \
        #           '"%.2f")\nStoreDoubleParameter("%s", "%.2f")\nStoreDoubleParameter("%s", ' \
        #           '"%.2f")\nStoreDoubleParameter("%s", "%.2f")\nStoreDoubleParameter("%s", ' \
        #           '"%.2f")\nStoreDoubleParameter("%s", "%.2f")\nRebuildOnParametricChange (bfullRebuild, ' \
        #           'bShowErrorMsgBox)\nEnd Sub' % (
        #               para_name1, para_value1, para_name2, para_value2, para_name3, para_value3, para_name4,
        #               para_value4, para_name5, para_value5, para_name6, para_value6, para_name7, para_value7)
        # 执行修改变量脚本
        # res = current_project.schematic.execute_vba_code(command, timeout=None)
        # 运行仿真
        current_project.modeler.run_solver()
        result_project = cst.results.ProjectFile(self.cst_full_path, allow_interactive=True)
        ids = result_project.get_3d().get_all_run_ids()
        # 获得吸收率曲线
        absorption = result_project.get_3d().get_result_item(r'Tables\1D Results\A', ids[-1])
        x_data = absorption.get_xdata()
        y_data = absorption.get_ydata()
        print("当前run id：", ids[-1])
        min_freq = 0
        max_freq = 0
        interval = 0
        open = False
        for i in absorption.get_ydata():
            if i.real >= 0.9 and open == False:
                min_freq = x_data[y_data.index(i)]
                open = True
            if i.real <= 0.9 and open:
                max_freq = x_data[y_data.index(i)]
                open = False
                print("min_freq, max_freq: ", min_freq, max_freq)
                interval += max_freq - min_freq

        print("interval: ", interval)
        return interval


# matrix = [[1, 1, 1, 0, 0],
#           [1, 1, 1, 1, 0],
#           [0, 1, 0, 1, 1],
#           [1, 0, 1, 0, 0],
#           [0, 0, 0, 0, 0]]
# absorb = CST_script()
# inter = absorb.material_init(matrix, 50, 19.4, 6.4)
# print(inter)
