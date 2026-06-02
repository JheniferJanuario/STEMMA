using STEMMA.Domain.Consultas.Entities;
using STEMMA.Domain.Consultas.Repositories;
using STEMMA.Application.Consultas.DTOs.Requests;

namespace STEMMA.Application.Consultas.UseCases;

public class CreateConsultationUseCase
{
    private readonly IConsultaRepository _consultaRepository;
    private readonly IDisponibilidadeRepository _disponibilidadeRepository;

    public CreateConsultationUseCase(
        IConsultaRepository consultaRepository,
        IDisponibilidadeRepository disponibilidadeRepository)
    {
        _consultaRepository = consultaRepository;
        _disponibilidadeRepository = disponibilidadeRepository;
    }

    public async Task ExecuteAsync(CreateConsultationRequest request)
    {
        var horarioOcupado =
            await _consultaRepository.ExisteConsultaNoHorarioAsync(
                request.VeterinarioId,
                request.DataConsulta);

        if (horarioOcupado)
            throw new Exception(
                "Já existe uma consulta agendada neste horário.");

        var disponibilidades = await _disponibilidadeRepository
            .ObterPorVeterinarioAsync(request.VeterinarioId);

        var estaDisponivel = disponibilidades.Any(d =>
            request.DataConsulta >= d.DataInicio &&
            request.DataConsulta < d.DataFim);

        if (!estaDisponivel)
            throw new Exception(
                "Veterinário não está disponível neste horário.");

        var consulta = new Consulta(
            request.PetId,
            request.VeterinarioId,
            request.DataConsulta
        );

        await _consultaRepository.AdicionarAsync(consulta);
    }
}