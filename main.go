package main

import (
	"fmt"
	"io"
	"os"
	"os/exec"
	"os/signal"
	"strings"
	"syscall"
	"time"
)

var (
	previousClip1 string
	previousClip2 string
	previousClip3 string
	previousClip4 string
	previousClip5 string
	recentInputs = make([]string, 5)
	currentIndex = 0
	pasteCmdArgs = "pbpaste"

)


func main() {
	// Create the output file if it doesn't exist
	outputPath := "/Users/" + os.Getenv("USER") + "/Desktop/copyHistory.txt"
	if _, err := os.Stat(outputPath); os.IsNotExist(err) {
		_, err := os.Create(outputPath)
		if err != nil {
			fmt.Println("Error creating file:", err)
			return
		}
	}

	file, err := os.OpenFile(outputPath, os.O_APPEND|os.O_WRONLY, 0644)
	if err != nil {
		fmt.Println("Error opening file:", err)
		return
	}
	defer file.Close()

	// Set up a ticker to check the clipboard every second
	ticker := time.NewTicker(1 * time.Second)
	quit := make(chan struct{})

	go func() {
		for {
			select {
			case <-ticker.C:
				checkClipboardChange(file)
			case <-quit:
				ticker.Stop()
				return
			}
		}
	}()

	// Set up a signal handler to stop the ticker on SIGINT
	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt, syscall.SIGTERM)
	go func() {
		<-c
		close(quit)
		os.Exit(0)
	}()

	// Keep the program running
	select {}
}

func getPasteCommand() *exec.Cmd {
	return exec.Command(pasteCmdArgs)
}

func readAll() (string, error) {
	pasteCmd := getPasteCommand()
	out, err := pasteCmd.Output()
	if err != nil {
		return "", err
	}
	return string(out), nil
}

func checkClipboardChange(file io.Writer) {
	clip, err := readAll()
	if err != nil {
		fmt.Println("Error reading clipboard:", err)
		return
	}
	clip = strings.TrimSpace(clip)
	if clip != previousClip1 || clip != previousClip2 || clip != previousClip3 || clip != previousClip4 || clip != previousClip5{
		previousClip1 = clip
		previousClip2 = previousClip1
		previousClip3 = previousClip2
		previousClip4 = previousClip3
		previousClip5 = previousClip4
		fmt.Println("\033[31;1m-------------------------You copied-------------------------\033[0m")
		fmt.Println("\033[32m" + clip + "\033[0m")
		writeToFile(file, clip)
	}
}

func writeToFile(file io.Writer, content string) {
	// Check if the content is already in recentInputs
	for _, input := range recentInputs {
		if input == content {
			return
		}
	}

	// Add the content to recentInputs
	recentInputs[currentIndex] = content
	currentIndex = (currentIndex + 1) % 5

	// Write the content to the file
	_, err := file.Write([]byte("\n\n • " + content))
	if err != nil {
		fmt.Println("Error writing to file:", err)
	}
}
