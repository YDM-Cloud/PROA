from scipy.spatial import ConvexHull
import numpy as np
import pandas as pd
import pyvista as pv


def read_txt(file):
    pcd = pd.read_csv(file, sep=',', header=None).values
    return pcd


def read_excel(file, sheet_name):
    pcd = pd.read_excel(file, sheet_name=sheet_name, header=None).values
    return pcd


def HPR(p, C, param=2):
    numPts, dim = np.shape(p)
    # move to points s.t. C is the origin
    p = p - np.tile(C, [numPts, 1])
    # calculate ||p||
    normp = np.reshape(np.sqrt(np.sum(p * p, axis=1)), [numPts, 1])
    # sphere radius
    R = np.tile(max(normp) * (10 ** param), [numPts, 1])
    # spherical flipping
    P = p + 2 * np.tile(R - normp, [1, dim]) * p / np.tile(normp, [1, dim])
    # convex hull
    visiblePtInds = np.unique(ConvexHull(np.r_[P, np.zeros([1, dim])]).simplices)
    visiblePtInds = visiblePtInds[:-1]
    return visiblePtInds


if __name__ == '__main__':
    # import x_best and x_history
    x_best = read_excel(r'x_best_and_history.xlsx', 'x_best')
    x_best = np.reshape(x_best, [-1, 3])
    x_best = pv.PolyData(x_best)
    x_history = read_excel(r'x_best_and_history.xlsx', 'x_history')
    x_history = np.reshape(x_history, [-1, 3])
    x_history = pv.PolyData(x_history)

    # import point cloud
    pcd = read_txt(r'F22-solidworks-整机点云.txt')
    tooling = read_txt(r'gz.txt')
    ground = read_txt(r'ground.txt')
    keypoints = np.array([
        [2.2e+02, 24., -6.4e+02],
        [-2.2e+02, 24., -6.4e+02],
        [19., 62., -5.9e+02],
        [-19., 60., -2.9e+02]
    ])
    total = np.r_[pcd, tooling, ground, keypoints]
    n_pcd = pcd.shape[0]

    # calculate indices of visible point
    visible_indices = None
    for i in range(6):
        indices = HPR(total, x_best.points[i, :])
        indices = indices[indices < n_pcd]
        if visible_indices is None:
            visible_indices = indices
        else:
            visible_indices = np.union1d(visible_indices, indices)

    colors = np.tile([255,69,0], [n_pcd, 1])
    colors[visible_indices, :] = np.array([50,205,50])
    pcd = pv.PolyData(pcd)
    pcd.point_data['_rgb'] = colors

    # convert tooling and key points to poly data
    tooling = pv.PolyData(tooling)
    keypoints = pv.PolyData(keypoints)

    # create domain surface
    vertexes = np.array([
        [394.174388020000, 257.575295187500, 91.4492290738095],
        [394.174388020000, -137.017850875000, 91.4492290738095],
        [-393.447025820000, -137.017850875000, 91.4492290738095],
        [-393.447025820000, 257.575295187500, 91.4492290738095],
        [-393.447025820000, 257.575295187500, 91.4492290738095],
        [-393.447025820000, 257.575295187500, -469.439334369048],
        [-393.447025820000, -137.017850875000, -469.439334369048],
        [-393.447025820000, -137.017850875000, 91.4492290738095],
        [-393.447025820000, 257.575295187500, -469.439334369048],
        [-393.447025820000, 257.575295187500, -1030.32789781191],
        [-393.447025820000, -137.017850875000, -1030.32789781191],
        [-393.447025820000, -137.017850875000, -469.439334369048],
        [394.174388020000, 257.575295187500, -1030.32789781191],
        [394.174388020000, -137.017850875000, -1030.32789781191],
        [-393.447025820000, -137.017850875000, -1030.32789781191],
        [-393.447025820000, 257.575295187500, -1030.32789781191],
        [394.174388020000, 257.575295187500, -469.439334369048],
        [394.174388020000, 257.575295187500, -1030.32789781191],
        [394.174388020000, -137.017850875000, -1030.32789781191],
        [394.174388020000, -137.017850875000, -469.439334369048],
        [394.174388020000, 257.575295187500, 91.4492290738095],
        [394.174388020000, 257.575295187500, -469.439334369048],
        [394.174388020000, -137.017850875000, -469.439334369048],
        [394.174388020000, -137.017850875000, 91.4492290738095]
    ])
    faces = []
    for i in range(6):
        faces.append(4)
        faces.extend([j for j in range(i * 4, (i + 1) * 4)])
    domain = pv.PolyData(vertexes, faces)

    # create ground
    ground_center = np.mean(vertexes, axis=0)
    ground_center[1] = np.min(vertexes[:, 1]) - 20
    ground = pv.Plane(center=ground_center, direction=(0, 1, 0), i_size=1500, j_size=1500, i_resolution=20,
                      j_resolution=20)

    # plot
    plotter = pv.Plotter()
    plotter.set_background('w')
    plotter.add_axes()
    plotter.add_mesh(domain, show_edges=True, color='#FFFF00', opacity=0.5)
    plotter.add_mesh(ground, color='#4682B4', show_edges=True)
    plotter.add_points(pcd, scalars='_rgb')
    plotter.add_points(tooling, color='#000080')
    plotter.add_points(keypoints, color='r', render_points_as_spheres=True, point_size=20)
    plotter.add_points(x_best, color='r', point_size=10)
    plotter.add_points(x_history, color='k')
    plotter.show()
