import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

def plot_7segment_6led_optimized():
    fig = plt.figure(figsize=(12, 12))
    ax = fig.add_subplot(111, projection='3d')
    
    # 6 LED positions (z=0) - horizontal line
    led_positions = {
        'LED1': [-2.5, 0, 0],    # → F (direct vertical up)
        'LED2': [-1.5, 0, 0],    # → E (direct vertical down)
        'LED3': [-0.5, 0, 0],    # → A (short angle up)
        'LED4': [0.5, 0, 0],     # → G (direct middle)
        'LED5': [1.5, 0, 0],     # → B (direct vertical up)
        'LED6': [2.5, 0, 0],     # → C & D (split down)
    }
    
    # Segment positions (z=5)
    segment_positions = {
        'A': [0, 2.5, 5],      # Top horizontal
        'B': [1.2, 1.5, 5],    # Top right vertical
        'C': [1.2, -1.5, 5],   # Bottom right vertical
        'D': [0, -2.5, 5],     # Bottom horizontal
        'E': [-1.2, -1.5, 5],  # Bottom left vertical
        'F': [-1.2, 1.5, 5],   # Top left vertical
        'G': [0, 0, 5],        # Middle horizontal
    }
    
    # Plot LEDs and segments
    for led, pos in led_positions.items():
        ax.scatter(*pos, color='red', s=100, label=led)
    for seg, pos in segment_positions.items():
        ax.scatter(*pos, color='blue', s=100, label=seg)
    
    # Plot optimized paths
    ax.plot(*zip(led_positions['LED1'], segment_positions['F']), 'g--', alpha=0.5)  
    ax.plot(*zip(led_positions['LED2'], segment_positions['E']), 'g--', alpha=0.5)  
    ax.plot(*zip(led_positions['LED3'], segment_positions['A']), 'g--', alpha=0.5)  
    ax.plot(*zip(led_positions['LED4'], segment_positions['G']), 'g--', alpha=0.5)  
    ax.plot(*zip(led_positions['LED5'], segment_positions['B']), 'g--', alpha=0.5)  
    ax.plot(*zip(led_positions['LED6'], segment_positions['C']), 'y--', alpha=0.5)  
    ax.plot(*zip(led_positions['LED6'], segment_positions['D']), 'y--', alpha=0.5)  
    
    # Customize plot
    ax.set_xlabel('X')
    ax.set_ylabel('Y')
    ax.set_zlabel('Z')
    ax.set_title('6-LED to 7-Segment Light Paths')
    
    # Add legend
    ax.legend()
    
    # Set equal aspect ratio
    ax.set_box_aspect([1,1,1])
    
    plt.show()

# Generate the plot
plot_7segment_6led_optimized()