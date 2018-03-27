## Dockerfile for the MathHub Backend

# Start from MMT 
FROM kwarc/mmt:release_10

RUN rm /root/MMT/deploy/mmtrc
ADD mmtrc /root/MMT/deploy/mmtrc

CMD ["--noshell", "-w", "server on 8080 0.0.0.0"]