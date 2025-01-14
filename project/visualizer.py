import pygame
import sys

pygame.init()

SCREEN_WIDTH = 800
SCREEN_HEIGHT = 800

WHITE = (255, 255, 255)
BLACK = (0, 0, 0)
RED = (255, 0, 0)
GREEN = (0, 255, 0)
BLUE = (0, 0, 255)
PURPLE = (128, 0, 128)

screen = pygame.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT))
pygame.display.set_caption('Grid Visualization')

font = pygame.font.Font(None, 36)

SEVEN_SPACES = ' ' * 7


def parse_input_file(filename):
    data = {
        'Hourglass': [],
        'Diamond': [],
        'Triangle': [],
        'Square': [],
        'TotalLineGeneration': 0,
        'TotalInstabilityGeneration': 0
    }
    max_rows = 0
    max_cols = 0

    with open(filename, 'r') as file:
        lines = file.readlines()
        start_idx = next((i for i, line in enumerate(
            lines) if "----     78 VARIABLE x.L  Binary placement of elements" in line), None)
        if start_idx is None:
            return data, 0, 0

        for i, line in enumerate(lines[start_idx:]):
            if "VARIABLE vTotalInstabilityGeneration.L =" in line:
                break

            values = line.strip().split()
            if len(values) >= 4:
                if values[3] == "vTotalLineGeneration.L":
                    data['TotalLineGeneration'] = float(values[5])
                    continue
                if values[1] == "vTotalInstabilityGeneration.L":
                    data['TotalInstabilityGeneration'] = float(values[3])
                    continue

            values = line.strip().split(SEVEN_SPACES)
            if len(values) == 1:
                continue
            elif len(values) == 2:
                data['Hourglass'].append(values[0])
            elif len(values) == 3:
                data['Diamond'].append(values[0])
            elif len(values) == 7:
                data['Triangle'].append(values[0])
            elif len(values) == 5:
                data['Square'].append(values[0])

            row, col = map(int, values[0].split('.'))
            max_rows = max(max_rows, row)
            max_cols = max(max_cols, col)

    return data, max_rows, max_cols


def draw_grid(maxRows, maxCols):
    """Draw the grid on the screen."""
    cell_width = SCREEN_WIDTH // maxCols
    cell_height = SCREEN_HEIGHT // maxRows

    # Draw vertical lines
    for x in range(0, SCREEN_WIDTH + 1, cell_width):
        pygame.draw.line(screen, BLACK, (x, 0), (x, SCREEN_HEIGHT))

    # Draw horizontal lines
    for y in range(0, SCREEN_HEIGHT + 1, cell_height):
        pygame.draw.line(screen, BLACK, (0, y), (SCREEN_WIDTH, y))


def draw_shape(shape_type, row, col, color, maxRows, maxCols):
    """Draw different shapes in the grid."""
    cell_width = SCREEN_WIDTH // maxCols
    cell_height = SCREEN_HEIGHT // maxRows

    # Calculate the center of the cell
    x = col * cell_width + cell_width // 2
    y = row * cell_height + cell_height // 2

    # Size of the shape (adjust as needed)
    size = min(cell_width, cell_height) // 2

    if shape_type == 'Hourglass':
        # Hourglass shape
        points = [
            (x - size, y - size),  # Top left
            (x + size, y - size),  # Top right
            (x, y),  # center
            (x - size, y + size),   # Bottom left
            (x + size, y + size),  # Bottom right
        ]
        pygame.draw.polygon(screen, color, points)

    elif shape_type == 'Diamond':
        # Diamond shape
        points = [
            (x, y - size),  # Top
            (x + size, y),  # Right
            (x, y + size),  # Bottom
            (x - size, y)   # Left
        ]
        pygame.draw.polygon(screen, color, points)

    elif shape_type == 'Triangle':
        # Triangle shape
        points = [
            (x, y - size),  # Top point
            (x - size, y + size),  # Bottom left
            (x + size, y + size)  # Bottom right
        ]
        pygame.draw.polygon(screen, color, points)

    elif shape_type == 'Square':
        points = [
            (x - size, y - size),  # Top left
            (x + size, y - size),  # Top right
            (x + size, y + size),  # Bottom right
            (x - size, y + size)   # Bottom left
        ]
        pygame.draw.polygon(screen, color, points)


def main():
    data, maxRows, maxCols = parse_input_file('project.lst')

    # Main game loop
    running = True
    while running:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False

        # Fill screen with white
        screen.fill(WHITE)

        # Draw grid
        draw_grid(maxRows, maxCols)

        # Draw shapes
        for pos in data['Hourglass']:
            row, col = map(int, pos.split('.'))
            draw_shape('Hourglass', row-1, col-1, RED, maxRows, maxCols)
        for pos in data['Diamond']:
            row, col = map(int, pos.split('.'))
            draw_shape('Diamond', row-1, col-1, GREEN, maxRows, maxCols)
        for pos in data['Triangle']:
            row, col = map(int, pos.split('.'))
            draw_shape('Triangle', row-1, col-1, BLUE, maxRows, maxCols)
        for pos in data['Square']:
            row, col = map(int, pos.split('.'))
            draw_shape('Square', row-1, col-1, PURPLE, maxRows, maxCols)

        # Update display
        pygame.display.flip()

    # Quit Pygame
    pygame.quit()
    sys.exit()


if __name__ == '__main__':
    main()
